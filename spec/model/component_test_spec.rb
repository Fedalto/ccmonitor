require 'model/component_test'

describe ComponentTest do
  before :each do
    ComponentTest.delete_all
  end

  describe "#create_or_update" do
    it "saves it if there is no saved model with the same name" do
      ComponentTest.all.size.should == 0
      ComponentTest.create_or_update(:name => :solr, :status => :success)
      ComponentTest.all.size.should == 1
      ComponentTest.all[0].name.should == :solr
    end

    it "updates it if there is already a saved model with the same name" do 
      ComponentTest.all.size.should == 0
      ComponentTest.create_or_update(:name => :solr, :status => :success)
      ComponentTest.all.size.should == 1
      ComponentTest.all[0].status.should == :success
      ComponentTest.create_or_update(:name => :solr, :status => :failure)
      ComponentTest.all[0].status.should == :failure
    end
  end
end

