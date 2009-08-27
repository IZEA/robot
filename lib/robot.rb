require 'robot/version'

class Robot
  autoload :Decorator,    'robot/decorator'
  autoload :Failsafe,     'robot/failsafe'
  autoload :Hoptoad,      'robot/hoptoad'
  autoload :Logger,       'robot/logger'
  autoload :Synchronizer, 'robot/synchronizer'
  autoload :Task,         'robot/task'
  
  class << self
    attr_accessor :robots
  end
  
  self.robots = {}
  
  attr_reader :name
  
  attr_accessor :logger
  attr_accessor :mutex
  attr_accessor :hoptoad
  attr_accessor :failsafe
  
  def log_info(msg)
    @logger.info(msg) if @logger
  end
  
  def perform(name, &block)
    @blocks << [name, block]
  end
  
  def run
    @blocks.each do |(name, block)|
      task = Task.new(name)
      task = Synchronizer.new(task, @mutex) if @mutex
      task = Logger.new(task, @logger)      if @logger
      task = Hoptoad.new(task, @hoptoad)    if @hoptoad
      task = Failsafe.new(task)             if @failsafe
      task.call(&block)
    end
  end
  
  def self.define(name)
    instance = new(name)
    yield(instance)
    self.robots[instance.name] = instance
  end
  
  def self.robot_by_name(name)
    self.robots[name] || raise(ArgumentError, "No such robot: #{name}")
  end
  
  def self.run(name)
    robot_by_name(name).run
  end
  
  private
  
  def initialize(name)
    @name = name
    @failsafe = true
    @blocks = []
  end
end
