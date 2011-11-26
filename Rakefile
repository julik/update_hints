# -*- ruby -*-

require 'rubygems'
require 'jeweler'
require './lib/update_hints'


Jeweler::Tasks.new do |gem|
  gem.version = UpdateHints::VERSION
  gem.name = "update_hints"
  gem.summary = "Automatically check if a new version of your gem is available and notify users"
  gem.email = "me@julik.nl"
  gem.homepage = "http://github.com/julik/update_hints"
  gem.authors = ["Julik Tarkhanov"]
  gem.license = 'MIT'
end

Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
desc "Run all tests"
Rake::TestTask.new("test") do |t|
  t.libs << "test"
  t.pattern = 'test/**/test_*.rb'
  t.verbose = true
end

task :default => [ :test ]
# vim: syntax=ruby
