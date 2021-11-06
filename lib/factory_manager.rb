# frozen_string_literal: true

# A factory manager of factory bots.
module FactoryManager
  autoload :Configuration, "factory_manager/configuration"
  autoload :Generator,     "factory_manager/generator"

  # Initializes and builds a new build generator.
  #
  # @yield Invokes the block to build the generator.
  def self.build(&block)
    Generator
      .new(strategy: :build)
      .generate(&block)
  end

  # Initializes and creates a new create generator.
  #
  # @yield Invokes the block to create the generator.
  def self.create(&block)
    Generator
      .new(strategy: :create)
      .generate(&block)
  end

  # Yields the current configuration object, allowing options to be modified.
  #
  # @example
  #   FactoryManager.configure do |configuration|
  #     configuration.alias_name = :factory_alias
  #   end
  #
  # @yield [Configuration] The current configuration.
  def self.configure
    yield configuration
  end

  # Returns the current configuration object, creating one when needed.
  #
  # @return [Configuration] The current configuration.
  def self.configuration
    @configuration ||= Configuration.new
  end
end
