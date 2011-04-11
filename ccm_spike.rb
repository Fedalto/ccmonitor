#!/usr/bin/env ruby

require 'sinatra'
require 'nokogiri'
require 'open-uri'

get '/' do
  file = open('http://metrics.gid.gap.com/cctray.xml', :proxy => nil)
  body << (erb :header)
  Nokogiri::XML(file).xpath('//Project').each do |project|
    @project = project
    body << (erb :project)
  end
  body
end
