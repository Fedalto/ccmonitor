#!/usr/bin/env ruby

require 'sinatra'
require 'nokogiri'
require 'open-uri'
require 'yaml'

config = YAML.load(File.read('config/config.yml'))

get '/' do
  file = open(config[:FEED_URL])
  body << (erb :header)
  Nokogiri::XML(file).xpath('//Project').each do |project|
    @project = project
    body << (erb :project)
  end
  body
end
