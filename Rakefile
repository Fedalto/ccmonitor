require 'bundler'
Bundler.require :test

namespace 'tests' do

  desc "run the acceptance tests"
  task :acceptance do
    sh 'bundle exec rspec spec/acceptance --color --format progress'
  end

  desc "run the unit tests"
  task :unit do
    sh 'RACK_ENV=test; bundle exec rspec spec/*_spec.rb --color --format progress'
  end

  desc "run the javascript tests"
  task :js do
    sh 'bundle exec rake jasmine:ci'
  end

end

task :spec => ["tests:unit", "tests:acceptance", "tests:js"]
task :default => :spec

#desc "require jasmine"
#task :require_jasmine do
  begin
    require 'jasmine'
    load 'jasmine/tasks/jasmine.rake'
  rescue LoadError
    task :jasmine do
      abort "Jasmine is not available. In order to run jasmine, you must: (sudo) gem install jasmine"
    end
  end
#end
