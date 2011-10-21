require 'rubygems'
require 'bundler'
require 'timeout'

Bundler.setup
Bundler.require :default

Dir["lib/**/*.rb"].each { |lib_file| load lib_file }

config_options = YAML.load(File.read("config/config.#{settings.environment}.yml"))

unless settings.environment == :test
  feed_reader = FeedReader.new config_options[:FEED_URL]

  activity_feeds = []
  config_options[:REAL_FEEDS].each do |feed|
    activity_feeds << ActivityReader.new(feed)
  end

  Thread.new do 
    while true
      feed_reader.run
      activity_feeds.each do |feed|
        feed.run
      end
      sleep(30)
    end
  end

end

set :logging, false
set :CONFIG, config_options
