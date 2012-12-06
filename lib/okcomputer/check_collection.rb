module OKComputer
  class CheckCollection
    attr_accessor :registry

    # Public: Initialize a new CheckCollection
    #
    # registry - a Hash of checks, with keys being unique names and values
    #   being Check instances
    def initialize(registry={})
      self.registry = registry
    end

    # Public: The list of checks in the collection
    #
    # Returns an Array of the registry's values
    def checks
      registry.values
    end

    # Public: The text of each check in the collection
    #
    # Returns a String
    def to_text
      checks.map(&:to_text).join("\n")
    end
  end
end
