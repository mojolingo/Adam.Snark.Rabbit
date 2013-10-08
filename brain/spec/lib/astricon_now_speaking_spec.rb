require 'spec_helper'
require 'timecop'

describe AstriconNowSpeaking do
  include NeuronMatchers

  let(:subject) { AstriconNowSpeaking.new }
  let(:ben) { ["What's Next: How to charge more by reinventing cloud PBX services", { speakers: ['Ben Klang'], start: DateTime.parse('2013-10-10 14:25 EDT'), end: DateTime.parse('2013-10-10 15:00 EDT'), room: 'Kennesaw', track: 'WebRTC/Cloud'}] }
  let(:entities) { {} }
  let(:wit) { wit_interpretation('foo', 'foo', entities) }
  let(:no_presentations) { "I don't see any presentations." }

  after do
    Timecop.return
  end

  it "should find Ben's presentation during his time" do
    Timecop.travel Time.local(2013, 10, 10, 18, 50, 0)
    subject.reply(nil, wit).should =~ /Ben Klang/
  end

  it "should find no presentations after the show ends" do
    Timecop.travel Time.local(2013, 10, 12, 18, 50, 0)
    subject.reply(nil, wit).should == no_presentations
  end

  context "with a specified time" do
    let(:entities) { {'datetime' => {'from' => "2013-10-10T14:30:00.000-04:00"} } }

    it "should find Ben's presentation with a requested time" do
      subject.reply(nil, wit).should =~ /Ben Klang/
    end
  end

  context "with a partially detected time element" do
    let(:entities) { {'datetime' => "2:30am tomorrow" } }

    it "should return a sensible error if the requested time isn't parsed by Wit" do
      subject.reply(nil, wit).should == no_presentations
    end
  end

  context "with an invalid specified time" do
    let(:entities) { {'datetime' => {'from' => "banana skyscraper ottoman"} } }

    it "should return a sensible error if the requested time isn't parsed by Wit" do
      subject.reply(nil, wit).should == "Sorry, I don't understand what time you mean?"
    end
  end
end

