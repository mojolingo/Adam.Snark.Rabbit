require 'spec_helper'

describe AstriconPresentations do
  let(:ben) { ["What's Next: How to charge more by reinventing cloud PBX services", { speakers: ['Ben Klang'], start: DateTime.parse('2013-10-10 14:25 EDT'), end: DateTime.parse('2013-10-10 15:00 EDT'), room: 'Kennesaw', track: 'WebRTC/Cloud'}] }

  context "finding by speaker name" do
    it "should find Ben's presentation" do
      AstriconPresentations.find_by_speaker("Ben Klang").first.should == ben
    end
  
    it "should find Ben's presentation with a misspelling of his name" do
      AstriconPresentations.find_by_speaker("Benn Clang").first.should == ben
    end
  end

  context "finding by room name" do
    it "should find Ben's presentation by room" do
      AstriconPresentations.find_by_room("Kennesaw").should include(ben)
    end
  
    it "should find Ben's presentation with a misspelling of his room" do
      AstriconPresentations.find_by_room("Kinisaw").should include(ben)
    end
  end

  context "finding by track name" do
    it "should find Ben's presentation by room" do
      AstriconPresentations.find_by_track('WebRTC/Cloud').should include(ben)
    end
  
    it "should find Ben's presentation with a misspelling of his room" do
      AstriconPresentations.find_by_track("webrtc").should include(ben)
    end
  end

  context "finding by time" do
    it "should find Ben's presentation by room" do
      AstriconPresentations.find_by_time(DateTime.parse('2013-10-10 14:50 EDT')).should include(ben)
    end
  end
end
