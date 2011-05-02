require 'rubygems'

class NameFilter

  def initialize
    @exclude_names = []
    @include_names = []
  end

  def should_include?(project)
    return @include_names.empty? ?
      !@exclude_names.any? {|name| project['name'].include? name} :
      (@include_names.any? {|name| project['name'].include? name} and !@exclude_names.any? {|name| project['name'].include? name} )
  end

  def exclude(name)
    @exclude_names << name
  end

  def include(name)
    @include_names << name
  end

  def filter(projects)
    projects.select { |project| should_include? project }
  end

end
