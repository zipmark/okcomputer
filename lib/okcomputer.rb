require "ok_computer/engine"
require "ok_computer/configuration"
require "ok_computer/check"
require "ok_computer/check_collection"
require "ok_computer/registry"

# and the built-in checks
require "ok_computer/built_in_checks/size_threshold_check"
require "ok_computer/built_in_checks/active_record_check"
require "ok_computer/built_in_checks/default_check"
require "ok_computer/built_in_checks/mongoid_check"
require "ok_computer/built_in_checks/resque_backed_up_check"
require "ok_computer/built_in_checks/resque_down_check"
require "ok_computer/built_in_checks/delayed_job_backed_up_check"
require "ok_computer/built_in_checks/ruby_version_check"
require "ok_computer/built_in_checks/cache_check"

OkComputer::Registry.register "default", OkComputer::DefaultCheck.new
OkComputer::Registry.register "database", OkComputer::ActiveRecordCheck.new
