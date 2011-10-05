require 'ccmonitor'
require 'capybara/dsl'

Bundler.require :test
set :logging, false

Dir['spec/support/**/*.rb'].each { |file| require file }
