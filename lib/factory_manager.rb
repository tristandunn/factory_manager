# frozen_string_literal: true

# A factory manager of factory bots.
class FactoryManager
  # Initializes a new factory.
  def initialize(strategy:)
    @locals = {}
    @results = {}
    @scopes = {}
    @strategy = strategy
  end

  # Initializes and builds a new factory.
  #
  # @yield Invokes the block to build the factory.
  def self.build(&block)
    instance = new(strategy: :build)
    instance.generate(&block)
  end

  # Initializes and creates a new factory.
  #
  # @yield Invokes the block to create the factory.
  def self.create(&block)
    instance = new(strategy: :create)
    instance.generate(&block)
  end

  # Generate the factory.
  #
  # @yield Invokes the block to generate the factory.
  # @return [OpenStruct] An object containing the record results.
  def generate(&block)
    instance_eval(&block)

    OpenStruct.new(@locals)
  end

  private

  # Add a record to a new or existing scope.
  #
  # @param [ActiveRecord::Base] The record to add to the scope.
  # @param [Symbol] scope The name of the scope.
  # @return [ActiveRecord::Base] The record.
  def _add_to_scope(record, scope:)
    @scopes[scope] ||= []
    @scopes[scope] << record

    yield

    @scopes[scope].pop
  end

  # Assign a local variable.
  #
  # @param [Symbol] method The method name for the local.
  # @param [*] value The value of the local.
  def _assign_local(method, value)
    @locals[method.to_s.tr("=", "")] = value
  end

  # Determine if a name is an assignment method.
  #
  # @param [Symbol] name The assignment method name.
  # @return [Boolean] Whether or not the name is an assignment method.
  def _assignment_method?(name)
    name.to_s.end_with?("=")
  end

  # Find the associations for a specific factory.
  #
  # @param [String] name The factory name.
  # @return [Hash] The associations for the factory.
  def _associations_for(name)
    @scopes
      .slice(*_factory_attributes(name))
      .transform_values(&:last)
  end

  # Determine all attribute names for a factory.
  #
  # @param [String] name The factory name.
  # @return [Array] The attributes for the factory.
  def _factory_attributes(name)
    @_factory_attributes ||= {}
    @_factory_attributes[name] ||= FactoryBot.factories.find(name).definition.attributes.names
  end

  # Generate a factory record with associations and custom attributes.
  #
  # @param [String] name The factory name.
  # @param [Hash] arguments The factory arguments.
  # @return [ActiveRecord::Base] The built factory record.
  def _generate_factory(name, *arguments)
    arguments.push(
      _associations_for(name).merge(arguments.extract_options!)
    )

    method = arguments.first.is_a?(Integer) ? "#{@strategy}_list" : @strategy

    FactoryBot.public_send(method, name, *arguments)
  end

  # Generate a factory record for the missing method.
  #
  # @param [Symbol] method The name of the method.
  # @param [Hash] arguments The factory arguments.
  # @return [ActiveRecord::Base] The built factory record.
  def method_missing(method, *arguments, &block)
    super unless respond_to_missing?(method)

    if _assignment_method?(method)
      _assign_local(method, arguments.first)
    else
      record = _generate_factory(method, *arguments)

      _add_to_scope(record, scope: method) do
        generate(&block) if block
      end

      record
    end
  end

  # Determine if a factory exists for the missing method, or if a local
  # variable is being assigned.
  #
  # @param [Symbol] method The name of the method.
  # @return [Boolean] Whether or not the factory exists.
  def respond_to_missing?(method)
    !FactoryBot.factories.find(method).nil?
  rescue KeyError
    _assignment_method?(method)
  end
end
