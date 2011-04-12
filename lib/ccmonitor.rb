require 'sinatra'
require 'open-uri'

module Ccmonitor

  config = YAML.load(File.read('config/config.yml'))

  get '/' do
    xml_file = open(config[:FEED_URL])
  end

end
