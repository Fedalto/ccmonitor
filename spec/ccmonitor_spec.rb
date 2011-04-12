require 'spec_helper'

describe Ccmonitor do

  def app
    Sinatra::Application
  end

  context "when receives a '/' request" do

    use_vcr_cassette

    before do
      stub_request(:any, "http://metrics.gid.gap.com/cctray.xml")
    end

    it 'should respond' do
      get '/'
      last_response.should be_ok
    end

    it 'should download the xml feed' do
      get '/'
      last_response.should be_ok
      a_request(:get, "http://metrics.gid.gap.com/cctray.xml").should have_been_made.once
    end

  end

end
