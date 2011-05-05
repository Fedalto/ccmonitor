require 'ccmonitor'

Bundler.require :test

require 'capybara/dsl'

Dir['spec/support/**/*.rb'].each { |file| require file }
