require 'spec_helper'

require_relative '../../lib/message_handler'

describe MessageHandler do
  let(:message_body) { "Hello" }
  let :message do
    AdamCommon::Message.new source_type: :xmpp,
                source_address: 'foo@bar.com',
                body: message_body
  end

  def response_with_body(body)
    AdamCommon::Response.new target_type: :xmpp,
                target_address: 'foo@bar.com',
                body: body
  end

  subject { described_class.new message }

  its(:response) { should == response_with_body("Why hello there!") }

  context "with a message that we don't understand" do
    let(:message_body) { "Lorem ipsum" }

    its(:response) { should == response_with_body("Sorry, I don't understand.") }
  end
end
