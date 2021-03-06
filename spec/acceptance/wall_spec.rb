require 'spec/spec_helper'
require 'stringio'

describe 'wall' do
  before :all do
    Kernel.silence_warnings do
      STDOUT = StringIO.new
    end
  end

  before { visit '/wall' }

  it 'should show a failure box' do
    page.should have_xpath "//div[@id='failure_box']"
  end

  it 'should show a success box' do
    page.should have_xpath "//div[@id='success_box']"
  end

  it 'should have a failing build' do
    find('#failure_box').find('h5').text.should == 'quick'
  end

  it 'should have a success build' do
    find('#success_box').find('h5').text.should == 'long'
  end

  it 'should have a box for the sounds' do
    page.should have_xpath "//div[@id='sounds']"
  end

  it 'should have a success sound' do
    page.should have_xpath "//audio[@id='success_sound']"
  end

  it 'should have a failure sound' do
    page.should have_xpath "//audio[@id='failure_sound']"
  end
end

describe 'feed unavailable' do
  before(:each) do
    FeedReader.new('invalid_file.xml').run
  end

  it 'should show the error page' do
    visit '/wall' 

    page.should have_xpath "//div[@id='error_box']"
  end
end
