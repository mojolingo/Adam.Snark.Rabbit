require 'spec_helper'
require_relative '../../lib/message_processor'

describe MessageProcessor do
  describe "processing a message" do
    let :message do
      AdamCommon::Message.new source_type: :xmpp,
                  source_address: 'foo@bar.com',
                  body: "Hello"
    end

    subject(:processor) { described_class.new message }

    it "should add user data to the message" do
      user = JSON.dump name: 'Ben'
      stub_request(:get, 'http://internal:foobar@local.adamrabbit.com/users/find_for_message.json')
        .with(query: {message: message.to_json})
        .to_return(body: user, headers: {'Content-Type' => 'application/json'})
      processor.processed_message.user.should == {'name' => 'Ben'}
    end

    context "when the user cannot be found" do
      before do
        stub_request(:get, 'http://internal:foobar@local.adamrabbit.com/users/find_for_message.json')
          .with(query: {message: message.to_json})
          .to_return(status: 404, body: '', headers: {'Content-Type' => 'application/json'})
      end

      it "should set nil user data on the message" do
        processor.processed_message.user.should == nil
      end
    end
  end
end
