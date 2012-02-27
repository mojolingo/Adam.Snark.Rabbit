require 'spec_helper'

class MockMessage
  attr_accessor :from, :to, :body, :groupchat, :chat

  def initialize(from, to, body = nil)
    @from, @to, @body = Blather::JID.new(from), Blather::JID.new(to), body
    @groupchat, @chat = false, false
  end

  def groupchat?
    @groupchat
  end

  def chat?
    @chat
  end

  def reply
    r = self.dup
    r.to, r.from = self.from, self.to
    r
  end
end

describe MessageHandler do
  describe 'showing help message' do
    it 'should respond with help text' do
      @input = MockMessage.new 'bklang@mojolingo.com', 'arabbit@mojolingo.com', 'help'
      MessageHandler.respond_to(@input).body.include?('Things you can ask me:').should be true
    end
  end

  describe 'receiving an invalid request' do
    it 'should show a reasonable error message' do
      @input = MockMessage.new 'bklang@mojolingo.com', 'arabbit@mojolingo.com', 'j23ijlksdvjlqk23;lkja;wlkj'
      MessageHandler.respond_to(@input).body.should == "Now you're not making any sense at all!"
    end
  end

  describe 'reacting to groupchat messages' do
    before :each do
      @input = MockMessage.new 'internal-discuss@conference.mojolingo.com/requestor_nick', 'arabbit@mojolingo.com'
      @input.groupchat = true
    end

    it 'should only react to messages addressed to me' do
      @input.body = "So Ben, how's the leg?"
      MessageHandler.respond_to(@input).should be nil
    end

    it 'should react to messages addressed to me with bang syntax' do
      @input.body = '!blah blah invalid request'
      MessageHandler.respond_to(@input).should_not be nil
    end

    it 'should react to messages addressed to me with nick syntax' do
      @input.body = 'arabbit: blah blah invalid request'
      MessageHandler.respond_to(@input).should_not be nil
    end
  end

  describe 'fetching Status messages' do
    before :each do
      @input = MockMessage.new 'bklang@mojolingo.com', 'arabbit@mojolingo.com', 'get status for blangfeld'
    end

    it 'should fetch the latest status from the public timeline' do
      @input.body = 'get status'
      mock_status = [{"text"=>
   "Ben Langfeld (https://status.mojolingo.com/url/6) started following Adam Snark Rabbit (https://status.mojolingo.com/url/23).",
  "truncated"=>false,
  "created_at"=>"Fri Feb 17 15:37:43 -0500 2012",
  "in_reply_to_status_id"=>nil,
  "source"=>"activity",
  "id"=>308,
  "in_reply_to_user_id"=>nil,
  "in_reply_to_screen_name"=>nil,
  "geo"=>nil,
  "favorited"=>false,
  "user"=>
   {"id"=>4,
    "name"=>"Ben Langfeld",
    "screen_name"=>"blangfeld",
    "location"=>"Preston, UK",
    "description"=>nil,
    "profile_image_url"=>
     "https://secure.gravatar.com/avatar.php?gravatar_id=f4971cb1f368ba9a03f227469768bdf6&default=http%3A%2F%2Fstatus.mojolingo.com",
    "url"=>"http://langfeld.me",
    "protected"=>false,
    "followers_count"=>7,
    "friends_count"=>10,
    "created_at"=>"Mon Oct 17 07:35:54 -0400 2011",
    "favourites_count"=>0,
    "utc_offset"=>"0",
    "time_zone"=>"UTC",
    "statuses_count"=>45,
    "following"=>true,
    "statusnet_blocking"=>false,
    "notifications"=>true,
    "statusnet_profile_url"=>"https://status.mojolingo.com/blangfeld"},
  "statusnet_html"=>
   "<a href=\"https://status.mojolingo.com/blangfeld\">Ben Langfeld</a> started following arabbit",
  "statusnet_conversation_id"=>268}]

      StatusMessages.expects(:timeline).once.with(:public, 1).returns mock_status

      MessageHandler.respond_to(@input).body.should == '@blangfeld: "Ben Langfeld (https://status.mojolingo.com/url/6) started following Adam Snark Rabbit (https://status.mojolingo.com/url/23)."'
    end

    it 'should request the latest status for a given user' do
      mock_status = [{'text' => 'Ben Was Here', 'user' => {'screen_name' => 'blangfeld'}}]
      StatusMessages.expects(:last_status_for).once.with('blangfeld').returns mock_status

      MessageHandler.respond_to(@input).body.should == '@blangfeld: "Ben Was Here"'
    end

    it 'should respond with a generic message if no status messages are available' do
      mock_status = []
      StatusMessages.expects(:last_status_for).once.with("blangfeld").returns mock_status

      MessageHandler.respond_to(@input).body.should == "No status updates found for blangfeld"
    end

    it 'should properly handle server error messages' do
      @input.body = 'get status for wdrexler'
      mock_status = {"error"=>"No such user.",
                     "request"=>"/api/statuses/user_timeline.json?screen_name=wdrexler&count=1"}
      StatusMessages.expects(:last_status_for).once.with('wdrexler').returns mock_status

      MessageHandler.respond_to(@input).body.should == "Server reported an error: No such user."
    end
  end

  describe 'listing projects' do
    before :each do
      @input = MockMessage.new 'bklang@mojolingo.com', 'arabbit@mojolingo.com', 'list projects'
    end

    it 'should return a suitable message if no projects are found' do
      @input.body = 'list projects for Invalid Customer'
      MessageHandler.respond_to(@input).body.should == 'No matching projects found.'
    end

    it 'should list all projects when no customer name is specified' do
      pending "Need fixtures"
      MessageHandler.respond_to(@input).body.should == "Test Project (Big Customer)\nOther Project (Little Customer)"
    end

    it 'should list all projects filtered for a specific customer by name' do
      pending "Need fixtures"
      @input.body = 'list projects for Big Customer'
      MessageHandler.respond_to(@input).body.should == 'Test Project (Big Customer)'
    end
  end
end