# frozen_string_literal: true

# A factory manager of factory bots.
module FactoryManager
  autoload :Generator, "factory_manager/generator"

  # Initializes and builds a new build generator.
  #
  # @param [String|Symbol] name The name of the manager to build.
  # @yield Invokes the block to build the generator.
  def self.build(name = nil, &block)
    block ||= managers[name]

    Generator
      .new(strategy: :build)
      .generate(&block)
  end

  # Initializes and creates a new create generator.
  #
  # @param [String|Symbol] name The name of the manager to create.
  # @yield Invokes the block to create the generator.
  def self.create(name = nil, &block)
    block ||= managers[name]

    Generator
      .new(strategy: :create)
      .generate(&block)
  end

  # Returns the registered managers.
  #
  # @return [Hash] The registered managers.
  def self.managers
    @managers ||= {}
  end

  # Register a manager to reuse later.
  #
  # @param [String|Symbol] name The name of the manager being registered.
  def self.register(name, &block)
    if managers.key?(name)
      raise ArgumentError.new(%("#{name}" manager is already registered.))
    end

    managers[name] = block
  end
end
