require 'bundler'
Bundler.require :test

namespace 'tests' do

  task :acceptance do
    sh 'bundle exec rspec spec/acceptance --color --format nested'
  end

  task :unit do
    sh 'RACK_ENV=test; bundle exec rspec spec/*_spec.rb --color --format progress'
  end

  task :js => :require_jasmine do
    sh 'bundle exec rake jasmine:ci'
  end

  task :require_jasmine do
    require 'jasmine'
    load 'jasmine/tasks/jasmine.rake'
  end
end

task :spec => ["tests:unit", "tests:acceptance"]
task :default => :spec

begin
  require 'jasmine'
  load 'jasmine/tasks/jasmine.rake'
rescue LoadError
  task :jasmine do
    abort "Jasmine is not available. In order to run jasmine, you must: (sudo) gem install jasmine"
  end
end
