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
  session[:include_names] = params[:include_names].split(',') unless params[:include_names].nil?
  session[:exclude_names] = params[:exclude_names].split(',') unless params[:exclude_names].nil?
  session[:versions] = params[:versions].split(',') unless params[:versions].nil?
  erb :wall
end

get "/all_projects" do
  xml_feed = open(settings.CONFIG[:FEED_URL])
  parser = ProjectsParser.new
  session[:include_names].each { |filter| parser.include_name(filter) } unless session[:include_names].nil?
  session[:exclude_names].each { |filter| parser.exclude_name(filter) } unless session[:exclude_names].nil?
  session[:versions].each { |filter| parser.include_version(filter) } unless session[:versions].nil?
  JSON.generate(parser.parse xml_feed)
end
