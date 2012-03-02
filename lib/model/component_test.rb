require 'supermodel'

class ComponentTest < SuperModel::Base
  include SuperModel::Marshal::Model

  def self.create_or_update(params)
    if test = ComponentTest.find_by_name(params[:name]) then
      test.status = params[:status]
      test.save!
    else
      ComponentTest.new(params).save!
    end
  end

end
