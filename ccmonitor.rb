require 'rubygems'
require 'bundler'
require 'timeout'

Bundler.setup
Bundler.require :default

Dir["lib/**/*.rb"].each { |lib_file| load lib_file }

config_options = YAML.load(File.read("config/config.#{settings.environment}.yml"))

def log(msg)
  puts "#{Time.now}: #{msg}"
end

unless settings.environment == :test
  feed_reader = FeedReader.new config_options[:FEED_URL]
  Thread.new do 
    while true
      log 'Reading feed.'

      begin
        feed_reader.run
      rescue => e
        log "Exception thrown while reading feed: #{e}"
      end

      log 'Feed updated. Sleeping for 60 seconds.'
      sleep(60)
    end
  end
end

set :CONFIG, config_options
