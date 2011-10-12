require 'feed_reader'
require 'stringio'

describe FeedReader do
  before :all do
    Kernel.silence_warnings do
      STDOUT = StringIO.new
    end
  end

  before :each do
    BuildInfo.destroy_all
    SuperModel::Marshal.dump
  end

  it 'should load the xml and save the objects to the database' do
    reader = FeedReader.new 'resources/cctray.xml'
    reader.run

    build_info = BuildInfo.find_by_id('trunk-project-package')
    build_info.name.should == 'project'
    build_info.state.should == 'success'
    build_info.build_type.should == 'package'
    build_info.buildUrl.should == 'http://buildurl'

    build_info = BuildInfo.find_by_id('trunk-otherproject-quick')
    build_info.name.should == 'otherproject'
    build_info.state.should == 'failure'
    build_info.build_type.should == 'quick'
    build_info.buildUrl.should == "http://buildUrl2"
  end

  it 'should say time since last succeeded is zero if the info is new' do
    reader = FeedReader.new 'resources/cctray.xml'
    reader.run

    build_info = BuildInfo.find_by_id('trunk-project-package')
    build_info.time_since_green.should == 0
  end

  it 'should know how many seconds passed since last success build' do
    FeedReader.new('resources/cctray.xml').run
    sleep(3)
    FeedReader.new('resources/one-passing.xml').run

    build_info = BuildInfo.find_by_id('trunk-project-package')
    build_info.time_since_green.should == 0

    build_info = BuildInfo.find_by_id('trunk-otherproject-quick')
    build_info.time_since_green.should == 3

    build_info = BuildInfo.find_by_id('trunk-evenanotherproject-quick')
    build_info.time_since_green.should == 0
  end
  
  it 'should save the current time as last succeeded time if the info is new' do
    reader = FeedReader.new 'resources/cctray.xml'
    reader.run

    build_info = BuildInfo.find_by_id('trunk-project-package')
    build_info.last_succeeded.should be_within(2).of(Time.now)
  end

  it 'should save the current time if the build is successful' do
    FeedReader.new('resources/cctray.xml').run
    sleep(3)
    FeedReader.new('resources/one-passing.xml').run

    build_info = BuildInfo.find_by_id('trunk-evenanotherproject-quick')
    build_info.last_succeeded.should be_within(2).of(Time.now)
  end

  it 'should not save the current time if the build is still failing' do
    FeedReader.new('resources/cctray.xml').run
    sleep(3)
    FeedReader.new('resources/one-passing.xml').run

    build_info = BuildInfo.find_by_id('trunk-otherproject-quick')
    build_info.last_succeeded.should_not be_within(2).of(Time.now)
  end

  it 'should not mark a build as recent in the first run' do
    FeedReader.new('resources/cctray.xml').run

    build_info = BuildInfo.find_by_id('trunk-project-package')
    build_info.recent.should == false

    build_info = BuildInfo.find_by_id('trunk-otherproject-quick')
    build_info.recent.should == false

    build_info = BuildInfo.find_by_id('trunk-otherproject-quick')
    build_info.recent.should == false
  end

  it "should not mark a build as recent when the status didn't change" do
    FeedReader.new('resources/cctray.xml').run
    FeedReader.new('resources/one-passing.xml').run

    build_info = BuildInfo.find_by_id('trunk-otherproject-quick')
    build_info.recent.should == false
  end

  it "should mark a build as recent when the status changed to success" do
    FeedReader.new('resources/cctray.xml').run
    FeedReader.new('resources/one-passing.xml').run

    build_info = BuildInfo.find_by_id('trunk-evenanotherproject-quick')
    build_info.recent.should == true
  end

  it "should mark a build as recent when the status changed to failure" do
    FeedReader.new('resources/cctray.xml').run
    FeedReader.new('resources/one-failing.xml').run

    build_info = BuildInfo.find_by_id('trunk-project-package')
    build_info.recent.should == true
  end

  it "should mark feed status as ok when feed is valid" do
    FeedReader.new('resources/cctray.xml').run

    FeedStatus.find_by_id('resources/cctray.xml').ok?.should == true
  end

  it 'should make feed status as unnavailable when something fails' do
    FeedReader.new('resources/invalid.xml').run

    FeedStatus.find_by_id('resources/invalid.xml').ok?.should == false
  end
end
