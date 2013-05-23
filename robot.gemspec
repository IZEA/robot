# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "robot/version"

Gem::Specification.new do |s|
  s.name        = "robot"
  s.version     = Robot::VERSION::STRING
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Dray Lacy", "Grady Griffin", "Brian Fisher"]
  s.email       = "opensource@izea.com"
  s.homepage    = "https://github.com/IZEA/robot"
  s.summary     = %q{Use Robot to run scheduled jobs}
  s.description = %q{job scheduling gem}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
