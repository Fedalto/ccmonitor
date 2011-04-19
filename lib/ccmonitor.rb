require "rubygems"
require "sinatra"
require "open-uri"
require "yaml"
require 'json'

require 'projects_parser'

set :CONFIG, YAML.load(File.read("config/config.yml"))
set :root,  File.join(File.dirname(__FILE__), "..")
set :static, true

get "/wall" do # this is just a dummy/stub
  erb :wall
end

get "/all_projects" do
  xml_feed = open(settings.CONFIG[:FEED_URL])
  filter = params['filter']
  parser = ProjectsParser.new
  parser.add_filter(filter) unless filter.nil?
  JSON.generate(parser.parse xml_feed)
end
