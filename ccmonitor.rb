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
      begin
        feed_reader.run
        activity_feeds.each do |feed|
          feed.run
        end
        sleep(30)
      rescue Exception => e
        puts e
      end
    end
  end

  Thread.new do
    while true
      begin
        reader = ComponentTestReader.new(config_options[:SOLR_QUICK_URL])
        reader.parse_page
        ComponentTest.create_or_update(:name => :solr, :status => reader.test_status)
        sleep(60)
      rescue Exception => e
        puts e
      end
    end
  end


end

set :logging, false
set :CONFIG, config_options
