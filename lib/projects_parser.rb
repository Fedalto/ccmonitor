require 'nokogiri'
require 'json'

class ProjectsParser

  def initialize(xml)
    @data = Hash.new
    @data['projects'] = []
    Nokogiri::XML(xml).xpath('//Project').each do |project|
      proj = Hash.new
      proj['name'] = project.get_attribute('name')
      proj['state'] = project.get_attribute('lastBuildStatus').downcase!
      @data['projects'] << proj
    end
  end

  def to_json
    JSON.generate(@data)
  end

end
