require 'feed_reader'

describe FeedReader do

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
end
