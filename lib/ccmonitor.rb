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

get "/all_projects" do # this is just a dummy/stub
  %!{"projects": [
    {"name": "Awesome", "state": "success"},
    {"name": "Fun", "state": "success"},
    {"name": "Great", "state": "success"},
    {"name": "Interesting", "state": "success"},
    {"name": "Fantastic", "state": "success"},
    {"name": "Unbelievable", "state": "success"},
    {"name": "Preposterous", "state": "failure"},
    {"name": "Outrageous", "state": "failure"}
  ]}!
end

# This was a spike on filtering. Filters have to be moved to a session.
get "/all_projects_old" do
  xml_feed = open(settings.CONFIG[:FEED_URL])
  filter = params['filter']
  parser = ProjectsParser.new
  parser.add_filter(filter) unless filter.nil?
  JSON.generate(parser.parse xml_feed)
end
