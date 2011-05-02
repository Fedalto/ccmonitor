require 'bundler'
require 'jasmine'
load 'jasmine/tasks/jasmine.rake'

Bundler::GemHelper.install_tasks

task :default => :test

task :test do
  sh 'bundle exec rspec spec'
end
