require 'rubygems'
require 'bundler'
require 'timeout'

Bundler.setup
Bundler.require :default

Dir["lib/**/*.rb"].each { |lib_file| load lib_file }

config_options = YAML.load(File.read("config/config.#{settings.environment}.yml"))

SuperModel::Marshal.path = '/tmp/ccmonitordb.db'

unless settings.environment == :test
  feed_reader = FeedReader.new config_options[:FEED_URL]
  Thread.new do 
    while true
      begin
        Timeout::timeout(30) do
          puts 'Reading feed.'
          feed_reader.run
          puts 'Feed updated.'
          sleep(60)
        end
      rescue Timeout::Error => e
        puts 'Timeout reading feed.'
      end
    end
  end
end

set :CONFIG, config_options
