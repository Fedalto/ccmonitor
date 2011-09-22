class BuildInfoParser

  def self.parse(xml)
    @data = []
    Nokogiri::XML(xml).xpath('//Project').each do |project|
      version = project.get_attribute('name').split("-")[0]
      cdr = project.get_attribute('name').split("-")[1..-1].join('.')
      name = cdr.split('.')[0]
      type = cdr.split('.')[1..-1].join('.')
      assignedTo = project.get_attribute('assignedTo')

      build_info = BuildInfo.new
      build_info.name = name
      build_info.state = project.get_attribute('lastBuildStatus').downcase
      build_info.version = version
      build_info.build_type = type
      build_info.buildUrl = project.get_attribute('webUrl')
      build_info.assignedTo = assignedTo.empty? ? "-------" : assignedTo
      build_info.assignUrl = project.get_attribute('assignUrl')

      build_info.id = version + '-' + name + '-' + type

      @data << build_info
    end
    @data
  end

end
