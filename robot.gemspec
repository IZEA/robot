# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "robot/version"

Gem::Specification.new do |s|
  s.name        = "robot"
  s.version     = Robot::VERSION::STRING
  s.authors     = ["Dray Lacy"]
  s.email       = ["gradyg@izea.com"]
  s.homepage    = ""
  s.summary     = %q{Use Robot to run scheduled jobs}
  s.description = %q{job scheduling gem}

  s.rubyforge_project = "robot"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency "autotest"
  s.add_runtime_dependency "hoe"
  s.add_runtime_dependency "hoe-izea"
  s.add_runtime_dependency "izea-pid_mutex"
end
