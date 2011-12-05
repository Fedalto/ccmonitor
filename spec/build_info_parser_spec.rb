require 'model/build_info'
require 'build_info_parser'

describe BuildInfoParser do

  context 'when created with an xml' do

    before do
      @xml = %!
      <Projects>
        <Project name='trunk-acoolname-quick' activity='Sleeping' lastBuildStatus='Success' webUrl='someUrl' assignedTo="" assignUrl="assignUrl"/>
        <Project name='trunk-abettername-package' activity='Sleeping' lastBuildStatus='Success' webUrl='someUrl' assignedTo="person" assignUrl="assignUrl"/>
        <Project name='1.0-anevenbettername.isolated-test' activity='Sleeping' lastBuildStatus='Failure' webUrl='someUrl' assignedTo="person" assignUrl="assignUrl"/>
      </Projects>
      !

      @xml_with_empty_project = %!
      <Projects>
        <Project name='trunk-acoolname-quick' activity='Sleeping' lastBuildStatus='Success' webUrl='someUrl' assignedTo="" assignUrl="assignUrl"/>
        <Project name='' activity='Sleeping' lastBuildStatus='Success' webUrl='someUrl' assignedTo="person" assignUrl="assignUrl"/>
      </Projects>
      !

      @project1 = BuildInfo.new({'id' => 'trunk-acoolname-quick', 'name' => 'acoolname', 'version' => 'trunk', 'state' => 'success', 'activity' => 'sleeping', 'build_type' => 'quick', 'buildUrl' => 'someUrl', 'assignedTo' => '-------', 'assignUrl' => 'assignUrl'})
      @project2 = BuildInfo.new({'id' => 'trunk-abettername-package', 'name' => 'abettername', 'version' => 'trunk', 'state' => 'success','activity' => 'sleeping',  'build_type' => 'package', 'buildUrl' => 'someUrl', 'assignedTo' => 'person', 'assignUrl' => 'assignUrl'})
      @project3 = BuildInfo.new({'id' => '1.0-anevenbettername-isolated.test', 'name' => 'anevenbettername', 'version' => '1.0', 'state' => 'failure', 'activity' => 'sleeping', 'build_type' => 'isolated.test', 'buildUrl' => 'someUrl', 'assignedTo' => 'person', 'assignUrl' => 'assignUrl'})

    end

    it 'should generate a tag for each project' do
      BuildInfoParser.parse(@xml).should == [ @project1, @project2, @project3 ]
    end

    it 'should not fail when projects have empty names' do
      BuildInfoParser.parse(@xml_with_empty_project).should == [ @project1 ]
    end

  end

end
