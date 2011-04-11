#!/usr/bin/env ruby

require 'sinatra'
require 'nokogiri'
require 'open-uri'
require 'yaml'

config = YAML.load(File.read('config/config.yml'))

get '/all' do
  file = open(config[:FEED_URL])
  body << (erb :header)
  @projects = Nokogiri::XML(file).xpath('//Project')
  body << (erb :all_projects)
  body
end
