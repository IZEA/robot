module Robot
  # Task decorator which wraps the task inside a mutex lock.
  class Synchronizer < Decorator
    class SynchronizationError < StandardError # :nodoc:
    end
    
    attr_accessor :mutex
    
    # Attempts to obtain a lock on the mutex before delegating to the task's
    # #call method.  If this method is unable to obtain a lock, it will raise
    # SynchronizationError.
    def call
      if @mutex.try_lock
        begin
          super
        ensure
          @mutex.unlock
        end
      else
        raise SynchronizationError, "Task #{name.inspect} is already running"
      end
    end
    
    private
    
    def initialize(task, mutex)
      super(task)
      @mutex = mutex
    end
  end
end
