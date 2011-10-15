require 'activity_reader'
require 'stringio'

describe ActivityReader do
  before :all do
    Kernel.silence_warnings do
      STDOUT = StringIO.new
    end
  end

  before :each do
    FeedReader.new('resources/cctray.xml').run
  end

  it 'should update activity information for builds' do
    ActivityReader.new('resources/activity.xml').run

    BuildInfo.find_by_id('11.01-project-package').activity.should == 'sleeping'
    BuildInfo.find_by_id('11.01-otherproject-quick').activity.should == 'sleeping'
    BuildInfo.find_by_id('trunk-otherproject-quick').activity.should == 'building'
  end

  it 'should not stop the thread in case of exceptions' do
    ActivityReader.new('invalid').run
  end
end
