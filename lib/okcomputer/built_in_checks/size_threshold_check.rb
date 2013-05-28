module OKComputer
  class SizeThresholdCheck < Check
    attr_accessor :size_obj
    attr_accessor :threshold

    # Public: Initialize a check for a backed-up Resque queue
    #
    # size_obj - The object that responds to the size method
    # threshold - An Integer to compare the size object's count against to consider
    #   it backed up
    # options - list of options to be used for the check
    #   name is the only valid option currently, that can be used to override the
    #   default name given to the check
    def initialize(size_obj, threshold, options={})
      raise(ArgumentError, "Size Object must respond to size") unless size_obj.respond_to?(:size)
      self.size_obj = size_obj
      self.threshold = Integer(threshold)
      self.name = options[:name] || size_obj.class.to_s
    end

    # Public: Check whether the given queue is backed up
    def check
      if size <= threshold
        mark_message " #{name} at reasonable level (#{size})"
      else
        mark_failure
        mark_message "#{name} is over #{threshold} threshold! (#{size})"
      end
    end

    # Public: The number of jobs in the check's queue
    def size
      size_obj.size
    end
  end
end
