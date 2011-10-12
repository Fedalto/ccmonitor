require 'supermodel'

class FeedStatus < SuperModel::Base
  include SuperModel::Marshal::Model

  def ok?
    @attributes['status'] == 'ok'
  end
end
