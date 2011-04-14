require 'bundler'
require 'jasmine'
load 'jasmine/tasks/jasmine.rake'

Bundler::GemHelper.install_tasks

task :test do
  sh 'bundle exec rspec spec'
end
