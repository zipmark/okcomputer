module OKComputer
  class ResqueDownCheck < Check
    attr_accessor :queue

    # Public: Initilize a check for whether Resque is running
    #
    # queue - The name of the Resque queue to check
    def initialize(queue)
      self.queue = queue
    end

    # Public: Check whether Resque workers are working
    def call
      if queued?
        if working?
          "Resque is working through the queue."
        else
          mark_failure
          "Resque is DOWN. No workers are working the queue."
        end
      else
        "Resque is working. No jobs queued."
      end
    end

    # Public: Whether the given Resque queue has jobs
    #
    # Returns a Boolean
    def queued?
      Resque.size(queue) > 0
    end

    # Public: Whether the Resque has workers working on a job
    #
    # Returns a Boolean
    def working?
      Resque.workers.any?(&:working?)
    end
  end
end
