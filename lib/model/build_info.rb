require 'supermodel'

class BuildInfo < SuperModel::Base
  def ==(another)
    @attributes == another.attributes
  end
end
