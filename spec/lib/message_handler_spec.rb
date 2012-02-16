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

    mock_status = mock("status message")
    StatusMessages.expects(:last_status_for).once.with("blangfeld").returns mock_status
    mock_status.expects(:text).returns "Ben Was Here"

    MessageHandler.respond_to input
  end
end