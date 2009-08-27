class Robot
  # Task decorator which reports any errors to Hoptoad.
  class Hoptoad < Decorator
    # Runs the decorated task, reporting any exceptions that it raises.  Note
    # that the exceptions will be re-raised.
    def call
      super
    rescue Exception => exception
      handle_exception(exception)
      raise
    end
    
    private
    
    def initialize(task, notifier)
      super(task)
      @notifier = notifier
    end
    
    def handle_exception(exception) # :nodoc:
      @notifier.notify(exception)
    end
  end
end
