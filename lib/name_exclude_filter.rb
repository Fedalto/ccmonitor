require 'rubygems'

class NameExcludeFilter

  def initialize
    @names = []
  end

  def should_include?(project)
    return !@names.any? {|name| project['name'].include? name}
  end

  def add(name)
    @names << name
  end

  def filter(projects)
    result = {'projects' => []}    
    projects['projects'].each do |project|
      result['projects'] << project if should_include? project
    end
    result
  end

end
