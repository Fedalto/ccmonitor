require 'supermodel'

class BuildInfo < SuperModel::Base
  include SuperModel::Marshal::Model

  SuperModel::Marshal.path = '/tmp/ccmonitordb.db'

  def ==(another)
    @attributes == another.attributes
  end

  def succeeded?
    @attributes['state'] == 'success'
  end
end
