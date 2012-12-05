# Private: Storage of the checks which have been registered with OKComputer.
#
# No one is expected to interact directly with this class, but rather through
# the outer OKComputer interface.
module OKComputer
  class Checks
    # Public: The check registered to the given name
    #
    # check_name - The name of the check to retrieve
    #
    # Returns the registered check or raises Checks::CheckNotFound
    def self.registered_check(check_name)
      registry.fetch(check_name)
    rescue KeyError
      raise CheckNotFound, "No check registered with '#{check_name}'"
    end

    # Public: Register the given check with OKComputer
    #
    # check_name - The name of the check to retrieve
    # check_object - Instance of Checker to register
    def self.register(check_name, check_object)
      registry[check_name] = check_object
    end

    # Public: Remove the check of the given name being checked
    #
    # check_name - The name of the check to retrieve
    def self.deregister(check_name)
      registry.delete(check_name)
    end

    # Private: The list of registered checks, keyed by their unique names
    #
    # Returns a Hash
    def self.registry
      @registry ||= {}
    end

    # Public: The list of checks registered to the system
    #
    # Returns an Array of registered checks
    def self.registered_checks
      registry.values
    end

    # Public: The names of the checks registered to the system
    #
    # Returns an Array of registered names
    def self.registered_names
      registry.keys
    end

    # used when fetching a check that has not been registered
    CheckNotFound = Class.new(StandardError)
  end
end
