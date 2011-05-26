class TypeFilter

  def initialize
    @exclude_types = []
    @include_types = []
  end

  def should_include?(project)
    return @include_types.empty? ?
      !@exclude_types.any? {|type| project['type'].include? type} :
      (@include_types.any? {|type| project['type'].include? type} and !@exclude_types.any? {|type| project['type'].include? type} )
  end

  def exclude(type)
    @exclude_types << type
  end

  def include(type)
    @include_types << type
  end

  def filter(projects)
    projects.select { |project| should_include? project }
  end

end
