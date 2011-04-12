require 'spec_helper'

describe Ccmonitor do

  def app
    Sinatra::Application
  end

  context 'when receives / request' do

    use_vcr_cassette

    it 'should respond' do
      get '/'
      last_response.should be_ok
    end
  end

end
