__0.2.0 / 2012-02-07 Grady Griffin__

* added defaulting most robot options
  
  * failsafe
  * mutex
  * logger
  * hoptoad


__0.1.0 / 2009-08-27 Dray Lacy__

* 5 minor enhancements

  * Changed the way tasks are run. Rather than becoming methods on the Robot
    module (now a class), they are invoked using Robot.run(:task_name). So
    before, where you would call Robot.daily, you should now call
    Robot.run(:daily).
  * Moved the logger, mutex, hoptoad, etc. config from class-level to
    task-level, so you can define different loggers and mutexes for each task.
  * Changed the failsafe decorator so that it writes to $stderr instead of
    STDERR.
  * Also changed the failsafe decorator so that it only writes errors to
    $stderr if $VERBOSE is set to true (ie. if ruby is being run in strict, or
    "-w", mode).
  * Added tests.

__0.0.1 / 2009-08-25 Dray Lacy__

* 1 major enhancement

  * Birthday!
  * Extracted from SocialSpark
