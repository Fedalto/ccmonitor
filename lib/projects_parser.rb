require 'rubygems'
require 'nokogiri'

class ProjectsParser

  def initialize
    @include_versions = []
    @exclude_types = []
  end

  def should_include_version?(version)
    return @include_versions.empty? ? true : @include_versions.any? { |filter| version == filter}
  end

  def should_include_type?(version)
    return @exclude_types.empty? ? true : !@exclude_types.any? { |filter| version == filter}
  end

  def include_version(version)
    @include_versions << version
  end

  def exclude_type(type)
    @exclude_types << type
  end

  def parse(xml)
    @data = {'projects' => []}
    Nokogiri::XML(xml).xpath('//Project').each do |project|
      version = project.get_attribute('name').split("-")[0]
      name = project.get_attribute('name').split("-")[1]
      type = project.get_attribute('name').split("-")[2]
      if should_include_version? version
        if should_include_type? type
          proj = {'name' => name}
          proj['state'] = project.get_attribute('lastBuildStatus').downcase!
          proj['version'] = version
          proj['type'] = type
          @data['projects'] << proj
        end
      end
    end
    @data
  end

end
