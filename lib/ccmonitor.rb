require 'lib/projects_parser'
require 'lib/name_exclude_filter'
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
  session[:exclude_types] = params[:exclude_types].split(',') unless params[:exclude_types].nil?
  session[:versions] = params[:versions].split(',') unless params[:versions].nil?
  erb :wall
end

get "/all_projects" do
  xml_feed = open(settings.CONFIG[:FEED_URL])
  parser = ProjectsParser.new
  session[:include_names].each { |filter| parser.include_name(filter) } unless session[:include_names].nil?
  session[:exclude_types].each { |filter| parser.exclude_type(filter) } unless session[:exclude_types].nil?
  session[:versions].each { |filter| parser.include_version(filter) } unless session[:versions].nil?

  projects = parser.parse xml_feed

  name_exclude_filter = NameExcludeFilter.new
  session[:exclude_names].each { |name| name_exclude_filter.add(name) } unless session[:exclude_names].nil?

  projects = name_exclude_filter.filter projects

  JSON.generate(projects)
end
