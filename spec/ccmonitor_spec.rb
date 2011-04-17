require 'spec_helper'

describe 'Ccmonitor' do

  def app
    Sinatra::Application
  end

  context "when receives a '/all_projects' request" do

    before do
      set :CONFIG, {:FEED_URL => "resources/simple.xml"}
    end

    it 'should return a Json with all projects' do
      project1 = Hash.new
      project1['name'] = 'cool name'
      project1['state'] = 'success'
      project2 = Hash.new
      project2['name'] = 'even better name'
      project2['state'] = 'failure'

      expected = Hash.new
      expected['projects'] = []
      expected['projects'] << project1
      expected['projects'] << project2

      get '/all_projects'
      last_response.should be_ok
      JSON.parse(last_response.body).should == expected
    end

  end

end
