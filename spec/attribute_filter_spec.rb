require 'spec/spec_helper'

describe AttributeFilter do

  before do
    @project1 = {'name' => 'acoolname', 'version' => 'trunk', 'state' => 'success', 'type' => 'quick'}
    @project2 = {'name' => 'abettername', 'version' => 'trunk', 'state' => 'success', 'type' => 'package'}
    @project3 = {'name' => 'anevenbettername', 'version' => '1.0', 'state' => 'failure', 'type' => 'regression'}
  end

  let (:filter) { AttributeFilter.new 'name'}

  it 'should exclude a project by a part of an attribute' do
    filter.exclude('better')

    filter.filter([ @project1, @project2 ]).should == [ @project1 ]
  end

  it 'should exclude a list of projects by parts of the names' do
    filter.exclude('cool')
    filter.exclude('even')

    filter.filter([ @project1, @project2, @project3 ]).should == [ @project2 ]
  end

  it 'should include a project by a part of the name' do
    filter.include('cool')

    filter.filter([ @project1, @project2, @project3 ]).should == [ @project1 ]
  end

  it 'should include a list of projects by parts of the names' do
    filter.include('cool')
    filter.include('even')

    filter.filter([ @project1, @project2, @project3 ]).should == [ @project1, @project3 ]
  end

  it 'should give preference to includes' do
    filter.include('better')
    filter.exclude('even')

    filter.filter([ @project1, @project2, @project3 ]).should == [ @project2 ]
  end

end
