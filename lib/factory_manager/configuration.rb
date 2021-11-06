# frozen_string_literal: true

module FactoryManager
  # Configuration class.
  class Configuration
    # @return [Symbol] The name used for aliasing factories.
    attr_reader :alias_name

    # Instantiated from {FactoryManager.configuration}. Sets the defaults.
    def initialize
      reset!
    end

    # Assigns the alias name, ensuring it's a symbol.
    #
    # @params [String|Symbol] name The name to use for factory aliases.
    def alias_name=(name)
      @alias_name = name.to_sym
    end

    # Resets the configuration to the defaults.
    def reset!
      self.alias_name = :alias
    end
  end
end
