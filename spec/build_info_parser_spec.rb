require 'model/build_info'
require 'build_info_parser'

describe BuildInfoParser do

  context 'when created with an xml' do

    before do
      @xml = %!
      <Projects>
        <Project name='trunk-acoolname-quick' activity='Sleeping' lastBuildStatus='Success' webUrl='someUrl'/>
        <Project name='trunk-abettername-package' activity='Building' lastBuildStatus='Success' webUrl='someUrl'/>
        <Project name='1.0-anevenbettername.isolated-test' activity='Sleeping' lastBuildStatus='Failure' webUrl='someUrl'/>
      </Projects>
      !

      @project1 = BuildInfo.new({'id' => 'trunk-acoolname-quick', 'name' => 'acoolname', 'version' => 'trunk', 'state' => 'success', 'build_type' => 'quick', 'buildUrl' => 'someUrl'})
      @project2 = BuildInfo.new({'id' => 'trunk-abettername-package', 'name' => 'abettername', 'version' => 'trunk', 'state' => 'success', 'build_type' => 'package', 'buildUrl' => 'someUrl'})

    end

    it 'should generate a tag for each project starting with trunk' do
      BuildInfoParser.parse(@xml).should == [ @project1, @project2 ]
    end

  end

end
