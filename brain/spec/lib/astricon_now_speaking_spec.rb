require 'spec_helper'
require 'timecop'

describe AstriconNowSpeaking do
  let(:subject) { AstriconNowSpeaking.new }
  let(:ben) { ["What's Next: How to charge more by reinventing cloud PBX services", { speakers: ['Ben Klang'], start: DateTime.parse('2013-10-10 14:25 EDT'), end: DateTime.parse('2013-10-10 15:00 EDT'), room: 'Kennesaw', track: 'WebRTC/Cloud'}] }

  after do
    Timecop.return
  end

  it "should find Ben's presentation during his time" do
    Timecop.travel Time.local(2013, 10, 10, 18, 50, 0)
    subject.reply(nil, nil).should =~ /Ben Klang/
  end

  it "should find no presentations after the show ends" do
    Timecop.travel Time.local(2013, 10, 12, 18, 50, 0)
    subject.reply(nil, nil).should == "There are no sessions on right now. Try back later."
  end
end

