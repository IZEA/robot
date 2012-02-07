require 'robot'
require 'test/unit'

class TestRobot < Test::Unit::TestCase
  class TestError < StandardError
  end
  
  class Mutex
    def try_lock
      @allow
    end
    
    def unlock
    end
    
    private
    
    def initialize(allow)
      @allow = allow
    end
  end
  
  class Logger
    attr_reader :infos
    attr_reader :fatals
    
    def info(msg)
      @infos << msg
    end
    
    def fatal(msg)
      @fatals << msg
    end
    
    private
    
    def initialize
      @infos = []
      @fatals = []
    end
  end
  
  def test_run
    block_was_run = false
    robot = Robot.new(:test)
    robot.perform('test') { block_was_run = true }
    
    assert ! block_was_run
    robot.run
    assert block_was_run
  end
  
  def test_failsafe
    robot = Robot.new(:test)
    robot.perform('test') { raise(TestError, "KABOOM") }
    
    silence_warnings { assert_nothing_raised { robot.run } }
  end
  
  def test_failsafe_class_default
    Robot.failsafe = true
    robot = Robot.new(:test)
    robot.perform('test') { raise(TestError, "KABOOM") }
    
    silence_warnings { assert_nothing_raised { robot.run } }
  end
  
  def test_failsafe_disabled
    robot = Robot.new(:test)
    robot.failsafe = false
    robot.perform('fail') { raise(TestError, "KABOOM") }
    
    assert_raises(TestError) { robot.run }
  end
  
  def test_failsafe_disabled_class_default
    Robot.failsafe = false
    robot = Robot.new(:test)
    robot.perform('fail') { raise(TestError, "KABOOM") }
    
    assert_raises(TestError) { robot.run }
  end
  
  def test_logger
    logger = Logger.new
    robot = Robot.new(:test)
    robot.logger = logger
    robot.perform('test') {}
    
    assert logger.infos.empty?
    robot.run
    assert_equal 2, logger.infos.size
    assert_equal 'Beginning test', logger.infos.first
    assert_match /Completed test \(\d+\.\d+s\)/, logger.infos.last
  end
  
  def test_logger_class_default
    Robot.logger = Logger.new
    robot = Robot.new(:test)
    robot.perform('test') {}
    logger = robot.logger
    
    assert logger.infos.empty?
    robot.run
    assert_equal 2, logger.infos.size
    assert_equal 'Beginning test', logger.infos.first
    assert_match /Completed test \(\d+\.\d+s\)/, logger.infos.last
  end
  
  def test_mutex
    mutex = Mutex.new(true)
    robot = Robot.new(:test)
    robot.mutex = mutex
    robot.perform('test') {}
    
    robot.run
  end
  
  def test_mutex_synchronize_error
    mutex = Mutex.new(false)
    robot = Robot.new(:test)
    robot.mutex = mutex
    robot.failsafe = false
    robot.perform('perform') {}
    
    exception = assert_raises(Robot::Synchronizer::SynchronizationError) { robot.run }
    assert_equal 'Task "perform" is already running', exception.message
  end

  def test_pid_class_default
    Robot.pid_root = Pathname.pwd.join('tmp')
    robot = Robot.new(:test)
    robot.failsafe = false
    robot.perform('perform') {}
    assert_equal true,!!robot.mutex
    assert_equal robot.mutex.class,PIDMutex
    assert_equal robot.mutex.pid_file.to_s, "#{Robot.pid_root}/robot.test.pid"
  end
  
  private
  
  def silence_warnings
    old_verbose, $VERBOSE = $VERBOSE, nil
    yield
  ensure
    $VERBOSE = old_verbose
  end
end
