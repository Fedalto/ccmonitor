require 'spec_helper'

describe 'Ccmonitor' do

  set :CONFIG, {:FEED_URL => "http://domain.com/cctray.xml"}

  def app
    Sinatra::Application
  end

  context "when receives a '/' request" do

    use_vcr_cassette

    before do
      stub_request(:any, "http://domain.com/cctray.xml")
      config = {:FEED_URL => "http://domain.com/cctray.xml"}
    end

    it 'should respond' do
      get '/'
      last_response.should be_ok
    end

    it 'should download the xml feed' do
      get '/'
      last_response.should be_ok
      a_request(:get, "http://domain.com/cctray.xml").should have_been_made.once
    end

  end

end
