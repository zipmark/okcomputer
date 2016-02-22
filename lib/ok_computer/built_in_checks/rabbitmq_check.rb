module OkComputer
  class RabbitmqCheck < Check
    def check
      mark_message "Connected Successfully"
      mark_message "Rabbit Connection Status: (#{connection_status})"
    rescue => e
      mark_failure
      mark_message "Error: '#{e}'"
    end

    def connection_status
      connection = Bunny.new(ENV['CLOUDAMQP_URL'] || ENV['AMQP_HOST'])
      connection.start
      status = connection.status
      connection.close
      status
    rescue => e
      raise ConnectionFailed, e
    end

    ConnectionFailed = Class.new(StandardError)
  end
end
