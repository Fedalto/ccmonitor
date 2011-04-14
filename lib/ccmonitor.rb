require 'sinatra'
require 'open-uri'

set :CONFIG, YAML.load(File.read('config/config.yml'))

get '/' do
  xml_file = open(settings.CONFIG[:FEED_URL])
end

