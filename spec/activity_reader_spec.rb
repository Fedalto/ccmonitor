require 'activity_reader'

describe ActivityReader do

  before :each do
    FeedReader.new('resources/cctray.xml').run
  end

  it 'should update activity information for builds' do
    ActivityReader.new('resources/activity.xml').run

    BuildInfo.find_by_id('11.01-project-package').activity.should == 'sleeping'
    BuildInfo.find_by_id('11.01-otherproject-quick').activity.should == 'sleeping'
    BuildInfo.find_by_id('trunk-otherproject-quick').activity.should == 'building'
  end
end
