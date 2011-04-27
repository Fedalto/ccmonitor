require 'spec_helper'

describe ProjectsParser do

  context 'when created with an xml' do

    before do
      @xml = %!
      <Projects>
        <Project name='a cool name' lastBuildStatus='Success' />
        <Project name='a better name' lastBuildStatus='Success' />
        <Project name='an even better name' lastBuildStatus='Failure' />
      </Projects>
      !

      @project1 = {'name' => 'a cool name', 'state' => 'success'}
      @project2 = {'name' => 'a better name', 'state' => 'success'}
      @project3 = {'name' => 'an even better name', 'state' => 'failure'}
      @expected = {'projects' => []}

      @parser = ProjectsParser.new
    end

    it 'should generate a tag for each project' do
      @expected['projects'] << @project1
      @expected['projects'] << @project2
      @expected['projects'] << @project3

      result = @parser.parse @xml

      result.should == @expected
    end

    it 'should exclude a project by a part of the name' do
      @expected['projects'] << @project1

      @parser.exclude('better')

      result = @parser.parse @xml

      result.should == @expected
    end

    it 'should exclude a list of projects by parts of the names' do
      @parser.exclude('cool')
      @parser.exclude('better')

      result = @parser.parse @xml

      result.should == @expected
    end

    it 'should include only the specified projects' do
      @expected['projects'] << @project1

      @parser.include('cool')

      result = @parser.parse @xml

      result.should == @expected
    end

    it 'include filters should have precedence' do
      @expected['projects'] << @project2

      @parser.include('better')
      @parser.exclude('even')

      result = @parser.parse @xml

      result.should == @expected
    end
  end


end
