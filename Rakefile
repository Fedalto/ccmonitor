require 'bundler'

require 'jasmine'
load 'jasmine/tasks/jasmine.rake'

namespace 'tests' do

  task 'acceptance' do
    sh 'rspec spec/acceptance'
  end

  task 'unit' do
    sh 'RACK_ENV=test rspec spec/*_spec.rb'
  end
end

task :spec => ["tests:unit", "tests:acceptance"]

task :default => :spec
