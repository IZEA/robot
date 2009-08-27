class Robot
  class Decorator
    attr_accessor :task
    
    def call(&block)
      @task.call(&block)
    end
    
    def name
      @task.name
    end
    
    private
    
    def initialize(task)
      @task = task
    end
  end
end
