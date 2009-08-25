module Robot
  class Task
    attr_reader :name
    
    def call
      yield
    end
    
    private
    
    def initialize(name)
      @name = name
    end
  end
end
