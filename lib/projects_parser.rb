class ProjectsParser

  def initialize
    @include_versions = []
    @exclude_types = []
  end

  def should_include_version?(version)
    return @include_versions.empty? ? true : @include_versions.any? { |filter| version == filter}
  end

  def should_include_type?(type)
    return @exclude_types.empty? ? true : !@exclude_types.any? { |filter| type.include? filter}
  end

  def include_version(version)
    @include_versions << version
  end

  def exclude_type(type)
    @exclude_types << type
  end

  def parse(xml)
    @data = []
    Nokogiri::XML(xml).xpath('//Project').each do |project|
      version = project.get_attribute('name').split("-")[0]
      cdr = project.get_attribute('name').split("-")[1..-1].join('.')
      name = cdr.split('.')[0]
      type = cdr.split('.')[1..-1].join('.')
      if should_include_version? version
        if should_include_type? type
          proj = {'name' => name}
          proj['state'] = project.get_attribute('lastBuildStatus').downcase
          proj['version'] = version
          proj['type'] = type
          proj['buildUrl'] = project.get_attribute('webUrl')
          proj['assignedTo'] = project.get_attribute('assignedTo')
          proj['assignUrl'] = project.get_attribute('assignUrl')
          @data << proj
        end
      end
    end
    @data
  end

end
