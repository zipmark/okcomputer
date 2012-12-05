require "okcomputer/engine"
require "okcomputer/check"
require "okcomputer/registry"

# and the built-in checks
require "okcomputer/built_in_checks/default_check"

module OKComputer
  # Public: Register the given check with the given name
  #
  # check_name - Unique name to give the check
  # check_object - Instance of Checker to register
  def self.register(check_name, check_object)
    Registry.register(check_name, check_object)
  end
end

OKComputer.register "default", OKComputer::DefaultCheck.new

