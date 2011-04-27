require 'rubygems'
require 'nokogiri'

class ProjectsParser

  def initialize
    @exclude_filters = []
    @include_filters = []
    @include_versions = []
  end

  def should_include_name?(name)
    return @include_filters.empty? ?
     !@exclude_filters.any? { |filter| name.include? filter } :
     (@include_filters.any? { |filter| name.include? filter } and !@exclude_filters.any? { |filter| name.include? filter })
  end

  def should_include_version?(version)
    return @include_versions.empty? ? true : @include_versions.any? { |filter| version == filter}
  end

  def exclude_name(name)
    @exclude_filters << name  
  end

  def include_name(name)
    @include_filters << name
  end

  def include_version(version)
    @include_versions << version
  end

  def parse(xml)
    @data = {'projects' => []}
    Nokogiri::XML(xml).xpath('//Project').each do |project|
      name = project.get_attribute('name').split("-")[1]
      version = project.get_attribute('name').split("-")[0]
      if should_include_name? name
        if should_include_version? version
          proj = {'name' => name}
          proj['state'] = project.get_attribute('lastBuildStatus').downcase!
          proj['version'] = version
          @data['projects'] << proj
        end
      end
    end
    @data
  end

end
