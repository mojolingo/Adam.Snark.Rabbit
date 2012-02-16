require 'spec_helper'

class MockMessage
  attr_accessor :from, :to, :body

  def initialize(from, to, body)
    @from, @to, @body = from, to, body
  end

  def reply
    r = self.dup
    r.to, r.from = self.from, self.to
    r
  end
end

describe MessageHandler do
  it 'should request the latest status for a given user' do
    input = MockMessage.new "bklang@mojolingo.com", "arabbit@mojolingo.com", "get status for blangfeld"

    mock_status = [{'text' => 'Ben Was Here'}]
    StatusMessages.expects(:last_status_for).once.with("blangfeld").returns mock_status

    MessageHandler.respond_to(input).body.should == "@blangfeld: \"Ben Was Here\""
  end

  it 'should respond with a generic message if no status messages are available' do
    input = MockMessage.new "bklang@mojolingo.com", "arabbit@mojolingo.com", "get status for blangfeld"

    mock_status = []
    StatusMessages.expects(:last_status_for).once.with("blangfeld").returns mock_status

    MessageHandler.respond_to(input).body.should == "No status updates found for blangfeld"
  end
end