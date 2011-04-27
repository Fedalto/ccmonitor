require 'spec_helper'

describe ProjectsParser do

  context 'when created with an xml' do

    before do
      @xml = %!
      <Projects>
        <Project name='trunk-acoolname' lastBuildStatus='Success' />
        <Project name='trunk-abettername' lastBuildStatus='Success' />
        <Project name='1.0-anevenbettername' lastBuildStatus='Failure' />
      </Projects>
      !

      @project1 = {'name' => 'acoolname', 'version' => 'trunk', 'state' => 'success'}
      @project2 = {'name' => 'abettername', 'version' => 'trunk', 'state' => 'success'}
      @project3 = {'name' => 'anevenbettername', 'version' => '1.0', 'state' => 'failure'}
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

      @parser.exclude_name('better')

      result = @parser.parse @xml

      result.should == @expected
    end

    it 'should exclude a list of projects by parts of the names' do
      @parser.exclude_name('cool')
      @parser.exclude_name('better')

      result = @parser.parse @xml

      result.should == @expected
    end

    it 'should include a project by a part of the name' do
      @expected['projects'] << @project1

      @parser.include_name('cool')

      result = @parser.parse @xml

      result.should == @expected
    end

    it 'should include a list of projects by parts of the names' do
      @expected['projects'] << @project1
      @expected['projects'] << @project3

      @parser.include_name('cool')
      @parser.include_name('even')

      result = @parser.parse @xml

      result.should == @expected
    end

    it 'include by name filters should have precedence over exclude by name filters' do
      @expected['projects'] << @project2

      @parser.include_name('better')
      @parser.exclude_name('even')

      result = @parser.parse @xml

      result.should == @expected
    end
  end


end
