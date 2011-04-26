require 'lib/projects_parser'
require "rubygems"
require "sinatra"
require "open-uri"
require "yaml"
require 'json'

set :CONFIG, YAML.load(File.read("config/config.yml"))
set :root,  File.join(File.dirname(__FILE__), "..")
set :static, true
set :sessions, true

get "/wall" do # this is just a dummy/stub
  session[:include] = params[:include].split(',') unless params[:include].nil?
  erb :wall
end

get "/all_projects" do # this is just a dummy/stub
  xml_feed = open(settings.CONFIG[:FEED_URL])
  parser = ProjectsParser.new
  session[:include].each { |filter| parser.include(filter) } unless session[:include].nil?
  JSON.generate(parser.parse xml_feed)
end
