# PIDMutex implements a simple semaphore that can be used to coordinate access
# to shared data from multiple concurrent processes.  It does this by managing
# access to a PID file.
# 
# Generally, this class is meant to be as close as possible to Ruby's standard
# Mutex class, so it can be easily swapped in its place for switching between
# thread- and process-based concurrency.
class PIDMutex
  # Amount of time (in seconds) to sleep while waiting for a lock to become
  # available.
  PERIOD = 0.005

  # Creates a new PIDMutex using the given +pid_file+.  The +pid_file+ is
  # expected to be a fully resolved path, but a file need not exist there
  # (PIDMutex will automatically create it).
  def initialize(pid_file)
    @pid_file = pid_file

    # Define a finalizer so that when this object is destroyed, it
    # automatically unlocks the PID file.
    ObjectSpace.define_finalizer(self, method(:unlock))
  end

  # Full path to the PID file.
  attr_reader :pid_file

  # Returns true if this lock is currently held by some process.
  def locked?
    return false unless File.exists?(@pid_file)
    
    begin
      pid = File.read(@pid_file)
    
      # if there is nothing in the file, delete the file and return false
      if pid.to_s.length == 0
        unlink_pid_file and return false
      end
    
      Process.kill 0, pid.to_i # this will raise Errno::ESRCH if there is a process
      
      true
    rescue Errno::ESRCH => e
      # no process, lets delete the pid and return false
      unlink_pid_file and return false
    end
    
  end

  # Obtains a lock, runs the block, and releases the lock when the block
  # completes.
  def synchronize # :yields:
    lock
    yield
  ensure
    unlock
  end

  # Attempts to grab the lock and waits if it isn‘t available.
  def lock
    sleep(PERIOD) until try_lock
  end

  # Attempts to obtain the lock and returns immediately. Returns true if the
  # lock was granted.
  def try_lock
    if locked?
      false
    else
      File.open(@pid_file, 'w') { |f| f.write(Process.pid) }
      File.chmod(0644, @pid_file)
      true
    end
  end

  # Removes the file (if any) created by #write_pid_file.
  def unlock
    return unless locked?
    unlink_pid_file
  end
  
  def unlink_pid_file
    File.unlink(@pid_file)
  end
end
