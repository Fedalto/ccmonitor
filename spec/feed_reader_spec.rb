require 'feed_reader'

describe FeedReader do

  after(:each) do
    BuildInfo.destroy_all
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
end
