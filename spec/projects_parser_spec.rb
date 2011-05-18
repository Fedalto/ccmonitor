require 'spec/spec_helper'

describe ProjectsParser do

  context 'when created with an xml' do

    before do
      @xml = %!
      <Projects>
        <Project name='trunk-acoolname-quick' lastBuildStatus='Success' webUrl='someUrl' assignedTo="person" assignUrl="assignUrl"/>
        <Project name='trunk-abettername-package' lastBuildStatus='Success' webUrl='someUrl' assignedTo="person" assignUrl="assignUrl"/>
        <Project name='1.0-anevenbettername.isolated-test' lastBuildStatus='Failure' webUrl='someUrl' assignedTo="person" assignUrl="assignUrl"/>
      </Projects>
      !

      @project1 = {'name' => 'acoolname', 'version' => 'trunk', 'state' => 'success', 'type' => 'quick', 'buildUrl' => 'someUrl', 'assignedTo' => 'person', 'assignUrl' => 'assignUrl'}
      @project2 = {'name' => 'abettername', 'version' => 'trunk', 'state' => 'success', 'type' => 'package', 'buildUrl' => 'someUrl', 'assignedTo' => 'person', 'assignUrl' => 'assignUrl'}
      @project3 = {'name' => 'anevenbettername', 'version' => '1.0', 'state' => 'failure', 'type' => 'isolated.test', 'buildUrl' => 'someUrl', 'assignedTo' => 'person', 'assignUrl' => 'assignUrl'}

      @parser = ProjectsParser.new
    end

    it 'should generate a tag for each project' do
      @parser.parse(@xml).should == [ @project1, @project2, @project3 ]
    end

    it 'should include by version' do
      @parser.include_version('trunk')

      @parser.parse(@xml).should == [ @project1, @project2 ]
    end

    it 'should include by a list of versions' do
      @parser.include_version('trunk')
      @parser.include_version('1.0')

      @parser.parse(@xml).should == [ @project1, @project2, @project3 ]
    end

    it 'should exclude by type' do
      @parser.exclude_type('isolated')

      @parser.parse(@xml).should == [ @project1, @project2 ]
    end

    it 'should exclude by a list of types' do
      @parser.exclude_type('package')
      @parser.exclude_type('isolated')

      @parser.parse(@xml).should == [ @project1 ]
    end

  end

end
