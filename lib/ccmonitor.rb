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
    {"name": "Awesome Project", "state": "success"},
    {"name": "Fun Project", "state": "success"},
    {"name": "Great Project", "state": "success"},
    {"name": "Interesting Project", "state": "success"},
    {"name": "Fantastic Project", "state": "success"},
    {"name": "Unbelievable Project", "state": "success"},
    {"name": "Preposterous Project", "state": "failure"},
    {"name": "Outrageous Project", "state": "failure"}
  ]}!
end
