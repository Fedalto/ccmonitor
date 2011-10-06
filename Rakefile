require 'bundler'
Bundler.require :test

namespace 'tests' do

  desc "Run the acceptance tests"
  task :acceptance do
    sh 'bundle exec rspec spec/acceptance --color --format progress'
  end

  desc "Run the unit tests"
  task :unit do
    sh 'RACK_ENV=test; bundle exec rspec spec/*_spec.rb --color --format progress'
  end

  desc "Run the javascript tests"
  task :js => [:require_jasmine] do
    Rake::Task['jasmine:ci'].invoke
  end

end

task :spec => ["tests:unit", "tests:acceptance", "tests:js"]
task :default => :spec

task :require_jasmine do
  begin
    require 'jasmine'
    load 'jasmine/tasks/jasmine.rake'
  rescue LoadError
    task :jasmine do
      abort "Jasmine is not available. In order to run jasmine, you must: (sudo) gem install jasmine"
    end
  end
end
