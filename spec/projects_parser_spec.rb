require 'spec_helper'
require 'json'

describe ProjectsParser do

  context 'when created with an xml' do

    before do
      @parser = ProjectsParser.new "<Projects><Project name='Awesome' lastBuildStatus='Success' /></Projects>"
    end

    it 'should generate a tag for each project' do
      expected = Hash.new
      a_project = Hash.new
      a_project['name'] = 'Awesome'
      a_project['state'] = 'success'
      expected['projects'] = []
      expected['projects'] << a_project

      json = @parser.to_json

      JSON.parse(json).should == expected
    end

  end


end
