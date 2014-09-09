$:.unshift File.expand_path('../lib/', __FILE__)

require 'rake/testtask'
require 'rake/clean'

# tests : rake test
Rake::TestTask.new do |t|
  t.libs << "test"
end

# Build the docs : rake docs
ronn_files = Rake::FileList['man/*.ronn']
html_docs = ronn_files.ext '.html'
man_docs = ronn_files.ext ''

ronn_files.each do |doc|
  # man file
  out = doc.ext ''
  file out => doc do
    sh "ronn --roff #{doc}"
  end
  CLEAN << out
  
  # html version
  out = doc.ext 'html'
  file out => doc do
    sh "ronn --html --style=toc  #{doc}"
  end
  CLEAN << out
end

desc "Build the manpages"
task :docs => html_docs + man_docs

task :default => :test
