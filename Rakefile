# -*- ruby -*-
require "bundler/gem_tasks"
require 'hoe'
require './lib/robot/version.rb'

Hoe.plugin(:izea)

Hoe.spec 'robot' do
  self.version = Robot::VERSION::STRING
  self.developer('Dray Lacy', 'dray@izea.com')
  self.extra_deps << ['hoe-izea', '>=0']
  
  pluggable!
end

# vim: syntax=ruby
