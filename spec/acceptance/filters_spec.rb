require 'spec/spec_helper'

describe 'name filter' do
  it 'should include only builds called evenanotherproject' do
    visit '/wall?include_names=evenanotherproject' 

    all('.cell').each do |cell|
      cell.find('h4').text.should == 'EVENANOTHERPROJECT'
    end
  end

  it 'should not include builds called otherproject' do
    visit '/wall?exclude_names=otherproject' 

    all('.cell').each do |cell|
      cell.find('h4').text.should == 'PROJECT'
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
