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

    build_info = BuildInfo.find_by_id('11.01-project-package')
    build_info.name.should == 'project'
    build_info.state.should == 'success'
    build_info.build_type.should == 'package'
    build_info.buildUrl.should == 'http://buildurl'
    build_info.assignedTo.should == 'duda'
    build_info.assignUrl.should == 'http://assignUrl'

    build_info = BuildInfo.find_by_id('11.01-otherproject-quick')
    build_info.name.should == 'otherproject'
    build_info.state.should == 'failure'
    build_info.build_type.should == 'quick'
    build_info.buildUrl.should == "http://buildUrl2"
    build_info.assignedTo.should == '-------'
    build_info.assignUrl.should == "http://assignUrl2"
  end

  it 'should not touch the activity field' do
    FeedReader.new('resources/activity.xml').run
    FeedReader.new('resources/cctray.xml').run
    
    build_info = BuildInfo.find_by_id('trunk-otherproject-quick')
    build_info.activity.should == 'building'
  end

  it 'should say time since last succeeded is zero if the info is new' do
    reader = FeedReader.new 'resources/cctray.xml'
    reader.run

    build_info = BuildInfo.find_by_id('11.01-project-package')
    build_info.time_since_green.should == 0
  end

  it 'should know how many seconds passed since last success build' do
    FeedReader.new('resources/cctray.xml').run
    sleep(3)
    FeedReader.new('resources/one-passing.xml').run

    build_info = BuildInfo.find_by_id('11.01-project-package')
    build_info.time_since_green.should == 0

    build_info = BuildInfo.find_by_id('11.01-otherproject-quick')
    build_info.time_since_green.should == 3

    build_info = BuildInfo.find_by_id('trunk-otherproject-quick')
    build_info.time_since_green.should == 0
  end
  
  it 'should save the current time as last succeeded time if the info is new' do
    reader = FeedReader.new 'resources/cctray.xml'
    reader.run

    build_info = BuildInfo.find_by_id('11.01-project-package')
    build_info.last_succeeded.should be_within(2).of(Time.now)
  end

  it 'should save the current time if the build is successful' do
    FeedReader.new('resources/cctray.xml').run
    sleep(3)
    FeedReader.new('resources/one-passing.xml').run

    build_info = BuildInfo.find_by_id('trunk-otherproject-quick')
    build_info.last_succeeded.should be_within(2).of(Time.now)
  end

  it 'should not save the current time if the build is still failing' do
    FeedReader.new('resources/cctray.xml').run
    sleep(3)
    FeedReader.new('resources/one-passing.xml').run

    build_info = BuildInfo.find_by_id('11.01-otherproject-quick')
    build_info.last_succeeded.should_not be_within(2).of(Time.now)
  end

  it 'should not mark a build as recent in the first run' do
    FeedReader.new('resources/cctray.xml').run

    build_info = BuildInfo.find_by_id('11.01-project-package')
    build_info.recent.should == false

    build_info = BuildInfo.find_by_id('11.01-otherproject-quick')
    build_info.recent.should == false

    build_info = BuildInfo.find_by_id('trunk-otherproject-quick')
    build_info.recent.should == false
  end

  it "should not mark a build as recent when the status didn't change" do
    FeedReader.new('resources/cctray.xml').run
    FeedReader.new('resources/one-passing.xml').run

    build_info = BuildInfo.find_by_id('11.01-otherproject-quick')
    build_info.recent.should == false
  end

  it "should mark a build as recent when the status changed to success" do
    FeedReader.new('resources/cctray.xml').run
    FeedReader.new('resources/one-passing.xml').run

    build_info = BuildInfo.find_by_id('trunk-otherproject-quick')
    build_info.recent.should == true
  end

  it "should mark a build as recent when the status changed to failure" do
    FeedReader.new('resources/cctray.xml').run
    FeedReader.new('resources/one-failing.xml').run

    build_info = BuildInfo.find_by_id('11.01-project-package')
    build_info.recent.should == true
  end

  it "should mark feed status as ok when feed is valid" do
    FeedReader.new('resources/cctray.xml').run

    FeedStatus.find_by_id('main_feed').ok?.should == true
  end

  it 'should make feed status as unnavailable when something fails' do
    FeedReader.new('resources/invalid.xml').run

    FeedStatus.find_by_id('main_feed').ok?.should == false
  end

  it 'should save the last updated time' do
    FeedReader.new('resources/cctray.xml').run

    BuildInfo.find_by_id('11.01-project-package').last_updated.should be_within(1).of(Time.now)
    BuildInfo.find_by_id('11.01-otherproject-quick').last_updated.should be_within(1).of(Time.now)
    BuildInfo.find_by_id('trunk-otherproject-quick').last_updated.should be_within(1).of(Time.now)
    BuildInfo.find_by_id('trunk-otherproject-long').last_updated.should be_within(1).of(Time.now)
  end

  it 'should not update the time if a build info is missing from the feed' do
    FeedReader.new('resources/cctray.xml').run
    sleep(2)
    FeedReader.new('resources/missing.xml').run

    BuildInfo.find_by_id('11.01-project-package').last_updated.should be_within(1).of(Time.now)
    BuildInfo.find_by_id('11.01-otherproject-quick').last_updated.should be_within(1).of(Time.now)
    BuildInfo.find_by_id('trunk-otherproject-long').last_updated.should be_within(1).of(Time.now)

    BuildInfo.find_by_id('trunk-otherproject-quick').last_updated.should_not be_within(1).of(Time.now)
  end

  it 'should delete builds that are missing for more then one hour' do
    FeedReader.new('resources/cctray.xml').run
    build_info = BuildInfo.find_by_id('trunk-otherproject-quick')
    build_info.last_updated = Time.now - (60 * 60 + 100)
    build_info.save!
    SuperModel::Marshal.dump
    FeedReader.new('resources/missing.xml').run

    BuildInfo.find_by_id('trunk-otherproject-quick').should be_nil
  end
end
