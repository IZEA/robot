require 'benchmark'

module Robot
  # Task decorator which adds logging and benchmarking.
  class Logger < Decorator
    attr_accessor :logger
    
    # Log the running time of the decorated task, as well as any exceptions
    # that are raised.
    def call
      @logger.info("Beginning #{name}")
      @logger.info('Completed %s (%.5fs)' % [name, Benchmark.realtime { super }])
    rescue Exception => exception
      log_exception(exception)
      raise
    end
    
    private
    
    def initialize(task, logger)
      super(task)
      @logger = logger
    end
    
    def log_exception(exception)
      message = "/!\\ ERROR /!\\  #{Time.now}\n"
      message << "  During task #{name.inspect}\n"
      message << "  #{exception}\n    #{exception.backtrace.join("\n    ")}" if exception
      @logger.fatal(message)
    end
  end
end
