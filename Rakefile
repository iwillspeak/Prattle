$:.unshift File.expand_path('../lib/', __FILE__)

require 'rake/testtask'
require 'rake/clean'

# tests : rake test
Rake::TestTask.new do |t|
  t.libs << "test"
end

task :default => [:test]