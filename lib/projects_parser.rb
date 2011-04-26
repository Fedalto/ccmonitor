require 'nokogiri'

class ProjectsParser

  def initialize
    @exclude_filters = []
    @include_filters = []
  end

  def should_include?(name)
    if @include_filters.empty?
      @exclude_filters.each { |filter| return false if name.include? filter }
      return true
    end
    @include_filters.each { |filter| return true if name.include? filter }
    return false
  end

  def exclude(name)
    @exclude_filters << name  
  end

  def include(name)
    @include_filters << name
  end

  def parse(xml)
    @data = {'projects' => []}
    Nokogiri::XML(xml).xpath('//Project').each do |project|
      name = project.get_attribute('name')
      if should_include? name
        proj = {'name' => name}
        proj['state'] = project.get_attribute('lastBuildStatus').downcase!
        @data['projects'] << proj
      end
    end
    @data
  end

end
