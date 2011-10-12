require 'spec/spec_helper'

describe 'feed_status' do
  before { visit '/feed_status' }

  it 'should show a feeds box' do
    page.should have_xpath "//div[@id='feed_box']"
  end
end
