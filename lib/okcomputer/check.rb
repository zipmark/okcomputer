module OKComputer
  class Check
    # to be set by Checks upon registration
    attr_accessor :name

    # Public: Perform the appropriate check
    #
    # Your subclass of Check must define its own perform method
    def perform
      raise(PerformNotDefined, "Your subclass must define its own #perform.")
    end

    # Public: The string output of performing the check
    #
    # Returns a String
    def to_s
      "#{name}: #{perform}"
    end

    # Public: The JSON output of performing the check
    #
    # Returns a String containing JSON
    def to_json
      {name => perform}.to_json
    end

    PerformNotDefined = Class.new(StandardError)
  end
end
