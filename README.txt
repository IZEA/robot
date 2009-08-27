= Robot

http://socialspark.com

== DESCRIPTION:

Robot does your bidding.  Use it for good, not for evil.

== FEATURES/PROBLEMS:

* Logs the start / end times of each task.
* Rescues exceptions so that if a task crashes, it won't take down the Robot
  itself.
* Synchronizes tasks using a mutex (either a standard Ruby Mutex or something
  that implements its interface). This ensures only one instance of Robot will
  run at a time.

== SYNOPSIS:

Add the following to an initializer (config/initializers/robot.rb):

  Robot.define(:hourly) do |robot|
    # Omit this line if you don't want logging, or define it as a custom logger
    # if you want a separate log file for your Robot tasks.
    robot.logger = Logger.new("log/robot.log")
    
    # Omit this line if you don't want to synchronize tasks. Adding a PIDMutex
    # here will ensure that only 1 process is running this task at any time.
    # Note that since PIDMutex uses a file as a locking mechanism, this method
    # doesn't scale beyond a single filesystem.
    robot.mutex = PIDMutex.new("tmp/pids/hourly.pid")
    
    # Omit this line if you're not using Hoptoad.
    robot.hoptoad = HoptoadNotifier
    
    # This is true by default, I'm just including it here as an example. If
    # you set it to false, then there won't be a failsafe mechanism, meaning
    # any exceptions raised by tasks will be unchecked. You'll usually want to
    # leave this set to true.
    robot.failsafe = true
    
    robot.perform("Some long-running task") { LongTask.run }
  end

And then add an entry to crontab to run your new Robot.hourly method:

  @hourly script/runner -e production "Robot.run(:hourly)"

== REQUIREMENTS:

* hoe
* hoe-izea
* izea-pid_mutex (for process-level locking, optional)

== INSTALL:

sudo gem install robot --source http://gems.izea.com

== LICENSE:

(The MIT License)

Copyright (c) 2009 Dray Lacy

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
