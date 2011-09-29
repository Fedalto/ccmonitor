require 'supermodel'

class BuildInfo < SuperModel::Base
  def ==(another)
    @attributes == another.attributes
  end

  def succeeded?
    @attributes['state'] == 'success'
  end
end
