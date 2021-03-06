require 'spec/spec_helper'
require 'stringio'

describe 'name filter' do
  before :all do
    Kernel.silence_warnings do
      STDOUT = StringIO.new
    end
  end

  it 'should include only builds called otherproject' do
    visit '/wall?include_names=otherproject' 

    all('.cell').each do |cell|
      cell.find('h4').text.should == 'OTHERPROJECT'
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
