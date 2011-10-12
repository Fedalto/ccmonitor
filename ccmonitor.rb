require 'rubygems'
require 'bundler'
require 'timeout'

Bundler.setup
Bundler.require :default

Dir["lib/**/*.rb"].each { |lib_file| load lib_file }

config_options = YAML.load(File.read("config/config.#{settings.environment}.yml"))

unless settings.environment == :test
  config_options[:FEEDS].each do |feed_url|
    feed_reader = FeedReader.new feed_url
    Thread.new do 
      while true
        feed_reader.run
        sleep(60)
      end
    end
  end
end

set :CONFIG, config_options
