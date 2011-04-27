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

get "/wall" do
  session[:include] = params[:include].split(',') unless params[:include].nil?
  session[:exclude] = params[:exclude].split(',') unless params[:exclude].nil?
  erb :wall
end

get "/all_projects" do
  xml_feed = open(settings.CONFIG[:FEED_URL])
  parser = ProjectsParser.new
  session[:include].each { |filter| parser.include_name(filter) } unless session[:include].nil?
  session[:exclude].each { |filter| parser.exclude_name(filter) } unless session[:exclude].nil?
  JSON.generate(parser.parse xml_feed)
end
