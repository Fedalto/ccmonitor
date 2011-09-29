require 'rubygems'
require 'bundler'

Bundler.setup
Bundler.require :default

Dir["lib/**/*.rb"].each { |lib_file| load lib_file }

config_options = YAML.load(File.read("config/config.#{settings.environment}.yml"))

feed_reader = FeedReader.new config_options[:FEED_URL]
Thread.new do 
  while true
    puts 'Reading feed.'
    feed_reader.run
    puts 'Feed updated.'
    sleep(60)
  end
end

set :CONFIG, config_options
