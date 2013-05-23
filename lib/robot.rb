require 'robot/version'
require 'pathname'
require 'mutex/pid_mutex'

class Robot
  autoload :Decorator,    'robot/decorator'
  autoload :Failsafe,     'robot/failsafe'
  autoload :Hoptoad,      'robot/hoptoad'
  autoload :Logger,       'robot/logger'
  autoload :Synchronizer, 'robot/synchronizer'
  autoload :Task,         'robot/task'
  
  class << self
    attr_accessor :robots
    attr_accessor :logger
    attr_accessor :pid_root
    attr_accessor :hoptoad
    attr_accessor :failsafe
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
    @failsafe = self.class.failsafe.nil? ? true : self.class.failsafe
    @logger = self.class.logger if self.class.logger
    @hoptoad = self.class.hoptoad if self.class.hoptoad
    @mutex = PIDMutex.new(self.class.pid_root.join("robot.#{name}.pid")) if self.class.pid_root 
    @blocks = []
  end
end
