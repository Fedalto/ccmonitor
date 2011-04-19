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

      @project1 = Hash.new
      @project1['name'] = 'a cool name'
      @project1['state'] = 'success'

      @project2 = Hash.new
      @project2['name'] = 'an even better name'
      @project2['state'] = 'failure'

      @expected = Hash.new
      @expected['projects'] = []

      @parser = ProjectsParser.new
    end

    it 'should generate a tag for each project' do
      @expected['projects'] << @project1
      @expected['projects'] << @project2

      result = @parser.parse @xml

      result.should == @expected
    end

    it 'should filter by project name' do
      @expected['projects'] << @project2

      @parser.add_filter('cool')

      result = @parser.parse @xml

      result.should == @expected
    end

  end


end
