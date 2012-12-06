module OKComputer
  class DatabaseCheck < Check
    # Public: Return the schema version of the database
    def call
      "Schema version: #{schema_version}"
    rescue ConnectionFailed => e
      "Failed to connect: '#{e}'"
    end

    # Public: The scema version of the app's database
    #
    # Returns a String with the version number
    def version
      ActiveRecord::Base.connection.select_value("SELECT MAX(version) FROM schema_migrations")
    rescue => e
      raise ConnectionFailed, e
    end

    ConnectionFailed = Class.new(StandardError)
  end
end
