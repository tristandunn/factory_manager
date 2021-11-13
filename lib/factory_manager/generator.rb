# frozen_string_literal: true

module FactoryManager
  # The factory manager generator.
  class Generator
    # Initializes a new factory generator.
    def initialize(strategy:)
      @associations = {}
      @locals = {}
      @results = {}
      @strategy = strategy
    end

    # Generates the factory.
    #
    # @yield Instance evaluates the block to generate the factory.
    # @return [OpenStruct] An object containing the generator results.
    def generate(&block)
      instance_eval(&block)

      OpenStruct.new(@locals)
    end

    private

    # Adds a record to a new or existing association.
    #
    # @param [ActiveRecord::Base] The record to add to the associations.
    # @param [Symbol] name The name of the association.
    # @return [ActiveRecord::Base] The record.
    def _add_association(record, name:)
      _factory_names(name).each do |factory_name|
        @associations[factory_name] ||= []
        @associations[factory_name] << record
      end

      yield

      _factory_names(name).each do |factory_name|
        @associations[factory_name].pop
      end

      record
    end

    # Assigns a local variable.
    #
    # @param [Symbol] method The method name for the local.
    # @param [*] value The value of the local.
    def _assign_local(method, value)
      @locals[method.to_s.tr("=", "")] = value
    end

    # Determines if the method is an assignment method.
    #
    # @param [Symbol] method The assignment method name.
    # @return [Boolean] Whether or not the method is an assignment method.
    def _assignment_method?(method)
      method.to_s.end_with?("=")
    end

    # Finds the matching associations for a specific factory.
    #
    # @param [String] name The factory name.
    # @return [Hash] The current associations for the factory.
    def _associations_for(name)
      @associations
        .slice(*_factory_attributes(name))
        .transform_values(&:last)
    end

    # Retrieves all attribute names for a factory.
    #
    # @param [String] name The factory name.
    # @return [Array] The attribute names for the factory.
    def _factory_attributes(name)
      @_factory_attributes ||= {}
      @_factory_attributes[name] ||= FactoryBot.factories.find(name).definition.attributes.names
    end

    # Returns the factory names up the nested tree.
    #
    # @param [String] name The factory name.
    # @return [Array] The names the factory can be referred to as.
    def _factory_names(name)
      factory = FactoryBot.factories.find(name)
      names   = []

      while factory.respond_to?(:names)
        names.push(*factory.names)

        factory = factory.__send__(:parent)
      end

      names
    end

    # Generates a factory record with associations and custom attributes.
    #
    # @param [String] name The factory name.
    # @param [Hash] arguments The factory arguments.
    # @return [ActiveRecord::Base] The built or created factory record.
    def _generate_factory(name, *arguments)
      arguments.push(
        _associations_for(name).merge(arguments.extract_options!)
      )

      method = arguments.first.is_a?(Integer) ? "#{@strategy}_list" : @strategy

      FactoryBot.public_send(method, name, *arguments)
    end

    # Attempts to generate a factory record for the missing method.
    #
    # Also handles assignments for the resulting generator object.
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

        _add_association(record, name: method) do
          generate(&block) if block
        end
      end
    end

    # Determines if a factory exists for the missing method, or if a variable
    # is being assigned.
    #
    # @param [Symbol] method The name of the method.
    # @return [Boolean] Whether or not the factory exists.
    def respond_to_missing?(method)
      !FactoryBot.factories.find(method).nil?
    rescue KeyError
      _assignment_method?(method)
    end
  end
end
