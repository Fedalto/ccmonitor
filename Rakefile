require 'bundler'

require 'jasmine'
load 'jasmine/tasks/jasmine.rake'
Bundler::GemHelper.install_tasks

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new :spec

namespace 'spec' do

  task 'acceptance' do
    sh 'rspec spec/acceptance'
  end

  task 'unit' do
    sh 'rspec spec/*_spec.rb'
  end
end


task :default => :spec
