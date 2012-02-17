require 'spec_helper'

class MockMessage
  attr_accessor :from, :to, :body

  def initialize(from, to, body = nil)
    @from, @to, @body = from, to, body
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

  describe 'fetching Status messages' do
    before :each do
      @input = MockMessage.new 'bklang@mojolingo.com', 'arabbit@mojolingo.com', 'get status for blangfeld'
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