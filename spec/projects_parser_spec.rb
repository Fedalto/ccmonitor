require 'spec_helper'
require 'json'

describe ProjectsParser do

  context 'when created with an xml' do

    before do
      @xml = "<Projects><Project name='Awesome' lastBuildStatus='Success' /></Projects>"
      @parser = ProjectsParser.new
    end

    it 'should generate a tag for each project' do
      expected = Hash.new
      a_project = Hash.new
      a_project['name'] = 'Awesome'
      a_project['state'] = 'success'
      expected['projects'] = []
      expected['projects'] << a_project

      result = @parser.parse @xml

      result.should == expected
    end

    it 'should filter by project name' do
      expected = Hash.new
      expected['projects'] = []

      @parser.add_filter('Awesome')

      result = @parser.parse @xml

      result.should == expected
    end

  end


end
