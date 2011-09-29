require 'spec/spec_helper'

describe 'wall' do
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
    find('#success_box').find('h5').text.should == 'package'
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

describe 'name filter' do
  it 'should include only builds called otherproject' do
    visit '/wall?include_names=otherproject' 

    all('.cell').each do |cell|
      cell.find('h4').text.should == 'otherproject'
    end
  end

  it 'should not include builds called otherproject' do
    visit '/wall?exclude_names=otherproject' 

    all('.cell').each do |cell|
      cell.find('h4').text.should == 'project'
    end
  end
end

describe 'type filter' do
  it 'should include only builds with type quick' do
    visit '/wall?include_types=quick' 

    all('.cell').each do |cell|
      cell.find('h5').text.should == 'quick'
    end
  end

  it 'should not include builds with type quick' do
    visit '/wall?exclude_names=otherproject' 

    all('.cell').each do |cell|
      cell.find('h5').text.should == 'package'
    end
  end
end
