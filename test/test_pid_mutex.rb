require 'test/unit'

class TestPIDMutex < Test::Unit::TestCase
  PID_FILE = "tmp/pidmutex.pid"
  def setup
    @mutex = PIDMutex.new(PID_FILE)
  end
  
  def teardown
    # Just in case a test doesn't clean up after itself.
    File.unlink(PID_FILE) if File.exists?(PID_FILE)
  end
  
  def test_no_file
    assert !File.exists?(PID_FILE)
    assert !@mutex.locked?
  end
  
  def test_file_with_no_corresponding_process_should_unlink_file
    File.open(PID_FILE, 'w') {|f| f.write('111111') }
    assert !@mutex.locked?
    assert !File.exists?(PID_FILE), "Checking locked mutex didn't remove erroneous file."
  end
  
  def test_empty_file_should_unlink_file
    File.open(PID_FILE, 'w') {|f| f.write('') }
    assert !@mutex.locked?
    assert !File.exists?(PID_FILE), "Checking locked mutex didn't remove erroneous file."
  end
  
  def test_file_with_current_pid_should_not_unlink_file
    File.open(PID_FILE, 'w') {|f| f.write(Process.pid.to_s) }
    assert @mutex.locked?
    assert File.exists?(PID_FILE), "PID file didn't exist."
  end
  
  def test_locking_mutex_should_create_file
    assert !File.exists?(PID_FILE), "PID file already exists."
    @mutex.lock
    assert File.exists?(PID_FILE), "PID file was not created."
  end
  
  def test_locking_mutex_should_update_locked_status
    assert !@mutex.locked?
    @mutex.lock
    assert @mutex.locked?
  end
  
  def test_synchronize_should_run_given_block
    block_was_run = false
    @mutex.synchronize { block_was_run = true }
    assert block_was_run
  end
  
  def test_unlock_should_deleted_file
    @mutex.lock
    assert File.exists?(PID_FILE)
    @mutex.unlock
    assert !File.exists?(PID_FILE), "Unlock didn't remove PID file."
  end
  
  def test_unlock_should_update_locked_status
    @mutex.lock
    assert @mutex.locked?
    @mutex.unlock
    assert !@mutex.locked?
  end
end