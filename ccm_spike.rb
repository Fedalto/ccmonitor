#!/usr/bin/env ruby

require 'sinatra'
require 'nokogiri'

get '/' do
  file = File.open('resources/cctray.xml')
  doc = Nokogiri::XML(file)
  projects = doc.xpath('//Project')
  projects.each do |project|
    @project = project
    body << (erb :project)
  end
  body
end
