require 'spec/spec_helper'

describe 'wall' do
  before { visit '/wall' }

  it 'should show failure box' do
    page.should have_xpath "//div[@id='failure_box']"
  end

  it 'should have a failed build' do
    find('#failure_box').find('h5').text.should == 'quick'
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
