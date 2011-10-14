require 'spec/spec_helper'
require "rack/test"

describe 'feed_status' do
  include Rack::Test::Methods

  before(:each) do
    FeedStatus.destroy_all
    FeedStatus.new({'id' => 'lol_id'}).save!
    SuperModel::Marshal.dump
    visit '/feed_status'
  end

  it 'should show a feeds box' do
    page.should have_xpath "//div[@id='feed_box']"
  end

  it 'should show a box for each feed' do
    page.should have_xpath "//div[@class='feed']"

    find('.feed').find('a').text.should == 'lol_id'
  end
end
