require 'spec_helper'

describe NameFilter do

  before do
    @project1 = {'name' => 'acoolname', 'version' => 'trunk', 'state' => 'success', 'type' => 'quick'}
    @project2 = {'name' => 'abettername', 'version' => 'trunk', 'state' => 'success', 'type' => 'package'}
    @project3 = {'name' => 'anevenbettername', 'version' => '1.0', 'state' => 'failure', 'type' => 'regression'}
    @input = {'projects' => []}
    @expected = {'projects' => []}
    @filter = NameFilter.new
  end

  it 'should exclude a project by a part of the name' do
    @input['projects'] << @project1
    @input['projects'] << @project2

    @expected['projects'] << @project1

    @filter.exclude('better')

    result = @filter.filter @input

    result.should == @expected
  end

  it 'should exclude a list of projects by parts of the names' do
    @input['projects'] << @project1
    @input['projects'] << @project2
    @input['projects'] << @project3

    @expected['projects'] << @project2

    @filter.exclude('cool')
    @filter.exclude('even')

    result = @filter.filter @input

    result.should == @expected
  end

  it 'should include a project by a part of the name' do
    @input['projects'] << @project1
    @input['projects'] << @project2
    @input['projects'] << @project3

    @expected['projects'] << @project1

    @filter.include('cool')

    result = @filter.filter @input

    result.should == @expected
  end

  it 'should include a list of projects by parts of the names' do
    @input['projects'] << @project1
    @input['projects'] << @project2
    @input['projects'] << @project3

    @expected['projects'] << @project1
    @expected['projects'] << @project3

    @filter.include('cool')
    @filter.include('even')

    result = @filter.filter @input

    result.should == @expected
  end

  it 'should give preference to includes' do
    @input['projects'] << @project1
    @input['projects'] << @project2
    @input['projects'] << @project3

    @expected['projects'] << @project2

    @filter.include('better')
    @filter.exclude('even')

    result = @filter.filter @input

    result.should == @expected
  end

end
