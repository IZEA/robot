module Robot
  # Task decorator which rescues any errors raised by the task.
  class Failsafe < Decorator
    # Runs the decorated task, rescuing any exceptions that it raises.
    def call
      super
    rescue Exception => exception
      # Eat any exceptions, so that other tasks can run.
      handle_exception(exception)
    end
    
    private
    
    def handle_exception(exception) # :nodoc:
      message = "/!\\ FAILSAFE /!\\  #{Time.now}\n"
      message << "  #{exception}\n    #{exception.backtrace.join("\n    ")}" if exception
      STDERR.puts(message)
    end
  end
end
