require 'nokogiri'

class ProjectsParser

  def initialize
    @filters = []
  end

  def should_include?(name)
    @filters.each do |filter|
      if name.include? filter
        return false
      end
    end
    true
  end

  def add_filter(name)
    @filters << name  
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
