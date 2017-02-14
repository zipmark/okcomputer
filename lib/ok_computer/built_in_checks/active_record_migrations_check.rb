module OkComputer
  class ActiveRecordMigrationsCheck < Check

    # Public: Check if migrations are pending or not
    def check
      return unsupported unless ActiveRecord::Migrator.respond_to?(:needs_migration?)

      if ActiveRecord::Migrator.needs_migration?
        mark_failure
        mark_message "Pending migrations"
      else
        mark_message "NO pending migrations"
      end
    end

    private

    # Private: Fail the check if ActiveRecord cannot check migration status
    def unsupported
      mark_failure
      mark_message "This version of ActiveRecord does not support checking whether migrations are pending"
    end
  end
end
