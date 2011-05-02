require 'spec/spec_helper'

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
