require 'spec/spec_helper'

describe TypeFilter do

  before do
    @project1 = {'name' => 'acoolname', 'version' => 'trunk', 'state' => 'success', 'type' => 'quick'}
    @project2 = {'name' => 'abettername', 'version' => 'trunk', 'state' => 'success', 'type' => 'package'}
    @project3 = {'name' => 'anevenbettername', 'version' => '1.0', 'state' => 'failure', 'type' => 'regression'}
  end

  let (:filter) { TypeFilter.new }

  it 'should exclude a project by a part of the type' do
    filter.exclude('packag')

    filter.filter([ @project1, @project2 ]).should == [ @project1 ]
  end

  it 'should exclude a list of projects by parts of the types' do
    filter.exclude('quick')
    filter.exclude('package')

    filter.filter([ @project1, @project2, @project3 ]).should == [ @project3 ]
  end

  it 'should include a project by a part of the type' do
    filter.include('quick')

    filter.filter([ @project1, @project2, @project3 ]).should == [ @project1 ]
  end

  it 'should include a list of projects by parts of the types' do
    filter.include('quick')
    filter.include('package')

    filter.filter([ @project1, @project2, @project3 ]).should == [ @project1, @project2 ]
  end

  it 'should give preference to includes' do
    filter.include('quick')
    filter.exclude('package')

    filter.filter([ @project1, @project2, @project3 ]).should == [ @project1 ]
  end

end
