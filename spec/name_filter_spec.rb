require 'spec_helper'

describe NameFilter do

  before do
    @project1 = {'name' => 'acoolname', 'version' => 'trunk', 'state' => 'success', 'type' => 'quick'}
    @project2 = {'name' => 'abettername', 'version' => 'trunk', 'state' => 'success', 'type' => 'package'}
    @project3 = {'name' => 'anevenbettername', 'version' => '1.0', 'state' => 'failure', 'type' => 'regression'}
    @filter = NameFilter.new
  end

  it 'should exclude a project by a part of the name' do
    @filter.exclude('better')

    result = @filter.filter [ @project1, @project2 ]

    result.should == [ @project1 ]
  end

  it 'should exclude a list of projects by parts of the names' do
    @filter.exclude('cool')
    @filter.exclude('even')

    result = @filter.filter [ @project1, @project2, @project3 ]

    result.should == [ @project2 ]
  end

  it 'should include a project by a part of the name' do
    @filter.include('cool')

    result = @filter.filter [ @project1, @project2, @project3 ]

    result.should == [ @project1 ]
  end

  it 'should include a list of projects by parts of the names' do
    @filter.include('cool')
    @filter.include('even')

    result = @filter.filter [ @project1, @project2, @project3 ]

    result.should == [ @project1, @project3 ]
  end

  it 'should give preference to includes' do
    @filter.include('better')
    @filter.exclude('even')

    result = @filter.filter [ @project1, @project2, @project3 ]

    result.should == [ @project2 ]
  end

end
