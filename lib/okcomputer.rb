require "okcomputer/engine"
require "okcomputer/check"
require "okcomputer/checks"

module OKComputer
  # Public: Register the given check with the given name
  #
  # check_name - Unique name to give the check
  # check_object - Instance of Checker to register
  def self.register(check_name, check_object)
    Checks.register(check_name, check_object)
  end
end
