class AttributeFilter

  def initialize(attribute_to_filter)
    @attribute_to_filter = attribute_to_filter
    @exclude = []
    @include = []
  end

  def should_include?(project)
    return @include.empty? ?
      !@exclude.any? {|attribute| project[@attribute_to_filter].include? attribute} :
      (@include.any? {|attribute| project[@attribute_to_filter].include? attribute} and !@exclude.any? {|attribute| project[@attribute_to_filter].include? attribute} )
  end

  def exclude(attribute)
    @exclude << attribute
  end

  def include(attribute)
    @include << attribute
  end

  def filter(projects)
    projects.select { |project| should_include? project }
  end

end
