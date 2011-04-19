require 'nokogiri'

class ProjectsParser

  def should_include?(name)
    if !@filter.nil?
      !name.include? @filter
    else
      true
    end
  end

  def add_filter(name)
    @filter = name  
  end

  def parse(xml)
    @data = Hash.new
    @data['projects'] = []
    Nokogiri::XML(xml).xpath('//Project').each do |project|
      name = project.get_attribute('name')
      if should_include? name
        proj = Hash.new
        proj['name'] = name
        proj['state'] = project.get_attribute('lastBuildStatus').downcase!
        @data['projects'] << proj
      end
    end
    @data
  end

end
