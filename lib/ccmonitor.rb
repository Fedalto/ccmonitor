require "rubygems"
require "sinatra"
require "open-uri"
require "yaml"

set :CONFIG, YAML.load(File.read("config/config.yml"))
set :root,  File.join(File.dirname(__FILE__), "..")
set :static, true

get "/" do
  xml_file = open(settings.CONFIG[:FEED_URL])
end

get "/wall" do # this is just a dummy/stub
  erb :wall

end

get "/all" do # this is just a dummy/stub
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
