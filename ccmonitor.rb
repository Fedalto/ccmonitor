require 'rubygems'
require 'bundler'

Bundler.setup
Bundler.require :default

Dir["lib/**/*.rb"].each { |lib_file| load lib_file }

set :app_file, __FILE__
set :CONFIG, YAML.load(File.read("config/config.yml"))
