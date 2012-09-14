require 'spec_helper'

require_relative '../../lib/message'
require_relative '../../lib/message_handler'

describe MessageHandler do
  let(:message_body) { "Hello" }
  let :message do
    Message.new source_type: :xmpp,
                source_address: 'foo@bar.com',
                body: message_body
  end

  subject { described_class.new message }

  its(:response) { should == "Why hello there!" }

  context "with a message that we don't understand" do
    let(:message_body) { "Lorem ipsum" }

    its(:response) { should == "Sorry, I don't understand." }
  end
end
