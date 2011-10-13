require 'rubygems'
require 'bundler'
require 'timeout'

Bundler.setup
Bundler.require :default

Dir["lib/**/*.rb"].each { |lib_file| load lib_file }

config_options = YAML.load(File.read("config/config.#{settings.environment}.yml"))

unless settings.environment == :test
  feeds = []
  config_options[:FEEDS].each do |feed_url|
    feeds << FeedReader.new(feed_url)
  end
  Thread.new do 
    while true
      feeds.each do |feed|
        feed.run
      end
      sleep(60)
    end
  end
end

set :CONFIG, config_options
