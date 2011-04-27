require 'rubygems'
require 'nokogiri'

class ProjectsParser

  def initialize
    @exclude_filters = []
    @include_filters = []
  end

  def should_include?(name)
    return @include_filters.empty? ?
     !@exclude_filters.any? { |filter| name.include? filter } :
     (@include_filters.any? { |filter| name.include? filter } and !@exclude_filters.any? { |filter| name.include? filter })
  end

  def exclude_name(name)
    @exclude_filters << name  
  end

  def include_name(name)
    @include_filters << name
  end

  def parse(xml)
    @data = {'projects' => []}
    Nokogiri::XML(xml).xpath('//Project').each do |project|
      version = project.get_attribute('name').split("-")[0]
      name = project.get_attribute('name').split("-")[1]
      if should_include? name
        proj = {'name' => name}
        proj['state'] = project.get_attribute('lastBuildStatus').downcase!
        proj['version'] = version
        @data['projects'] << proj
      end
    end
    @data
  end

end
