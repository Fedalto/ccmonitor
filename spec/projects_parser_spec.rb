require 'spec_helper'
require 'json'

describe ProjectsParser do

  context 'when created with an xml' do

    before do
      @xml = %!
      <Projects>
        <Project name='a cool name' lastBuildStatus='Success' />
        <Project name='an even better name' lastBuildStatus='Failure' />
      </Projects>
      !

      @project1 = {'name' => 'a cool name', 'state' => 'success'}
      @project2 = {'name' => 'an even better name', 'state' => 'failure'}
      @expected = {'projects' => []}

      @parser = ProjectsParser.new
    end

    it 'should generate a tag for each project' do
      @expected['projects'] << @project1
      @expected['projects'] << @project2

      result = @parser.parse @xml

      result.should == @expected
    end

    it 'should filter by project name' do
      @expected['projects'] << @project1

      @parser.add_filter('better')

      result = @parser.parse @xml

      result.should == @expected
    end

    it 'should filter by a list of project names' do
      @parser.add_filter('cool')
      @parser.add_filter('better')

      result = @parser.parse @xml

      result.should == @expected
    end
  end


end
