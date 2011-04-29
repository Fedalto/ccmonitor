require 'spec_helper'

describe ProjectsParser do

  context 'when created with an xml' do

    before do
      @xml = %!
      <Projects>
        <Project name='trunk-acoolname-quick' lastBuildStatus='Success' />
        <Project name='trunk-abettername-package' lastBuildStatus='Success' />
        <Project name='1.0-anevenbettername.isolated-test' lastBuildStatus='Failure' />
      </Projects>
      !

      @project1 = {'name' => 'acoolname', 'version' => 'trunk', 'state' => 'success', 'type' => 'quick'}
      @project2 = {'name' => 'abettername', 'version' => 'trunk', 'state' => 'success', 'type' => 'package'}
      @project3 = {'name' => 'anevenbettername', 'version' => '1.0', 'state' => 'failure', 'type' => 'isolated.test'}
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

    it 'should include by version' do
      @expected['projects'] << @project1
      @expected['projects'] << @project2

      @parser.include_version('trunk')

      result = @parser.parse @xml

      result.should == @expected
    end

    it 'should include by a list of versions' do
      @expected['projects'] << @project1
      @expected['projects'] << @project2
      @expected['projects'] << @project3

      @parser.include_version('trunk')
      @parser.include_version('1.0')

      result = @parser.parse @xml

      result.should == @expected
    end

    it 'should exclude by type' do
      @expected['projects'] << @project1
      @expected['projects'] << @project2

      @parser.exclude_type('isolated')

      result = @parser.parse @xml

      result.should == @expected
    end

    it 'should exclude by a list of types' do
      @expected['projects'] << @project1

      @parser.exclude_type('package')
      @parser.exclude_type('isolated')

      result = @parser.parse @xml

      result.should == @expected
    end

  end


end
