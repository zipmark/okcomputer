module OKComputer
  class Checks
    # Public: The check registered to the given name
    #
    # check_name - The name of the check to retrieve
    #
    # Returns the registered check or raises Checks::CheckNotFound
    def self.registered_check(check_name)
      (@registered_checks || {}).fetch(check_name)
    rescue KeyError
      raise CheckNotFound
    end

    # Public: Register the given check with OKComputer
    #
    # check_name - The name of the check to retrieve
    # check_object - Instance of Checker to register
    def self.register(check_name, check_object)
      @registered_checks ||= {}
      @registered_checks[check_name] = check_object
    end

    # Public: The list of checks registered to the system
    #
    # Returns an Array of registered checks
    def self.registered_checks
      (@registered_checks || {}).values
    end

    # Private: Store a new list of checks
    #
    # checks - A Hash with the name of the check as the key and the check for
    #   that name as the value
    def self.registered_checks=(checks)
      @registered_checks = checks
    end
    private_class_method :registered_checks=

    # used when fetching a check that has not been registered
    CheckNotFound = Class.new(StandardError)
  end
end
