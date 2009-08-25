require 'robot/version'

module Robot
  autoload :Decorator,    'robot/decorator'
  autoload :Failsafe,     'robot/failsafe'
  autoload :Hoptoad,      'robot/hoptoad'
  autoload :Logger,       'robot/logger'
  autoload :Synchronizer, 'robot/synchronizer'
  autoload :Task,         'robot/task'
  
  class << self
    attr_accessor :logger
    attr_accessor :mutex
    attr_accessor :hoptoad
  end
  
  def self.define(name, &block)
    (class << self; self; end).class_eval do
      define_method(name, &block)
    end
  end
  
  def self.log_info(msg)
    logger.info(msg) if logger
  end
  
  def self.perform(name, &block)
    task = Task.new(name)
    task = Synchronizer.new(task, mutex)  if mutex
    task = Logger.new(task, logger)       if logger
    task = Hoptoad.new(task, hoptoad)     if hoptoad
    task = Failsafe.new(task)
    task.call(&block)
  end
end
