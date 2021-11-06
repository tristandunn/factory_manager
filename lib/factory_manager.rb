# frozen_string_literal: true

# A factory manager of factory bots.
module FactoryManager
  autoload :Generator, "factory_manager/generator"

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
end
