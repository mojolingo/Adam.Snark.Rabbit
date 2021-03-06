require 'spec_helper'
require_relative '../../lib/message_processor'

describe MessageProcessor do
  describe "processing a message" do
    let :message do
      AdamSignals::Message.new source_type: :xmpp,
                  source_address: 'foo@bar.com',
                  body: "Hello"
    end

    subject(:processor) { described_class.new message }

    it "should add user data to the message" do
      user = JSON.dump name: 'Ben'
      stub_request(:get, 'http://internal:foobar@local.adamrabbit.com:3000/users/find_for_message.json')
        .with(query: {message: message.to_json})
        .to_return(body: user, headers: {'Content-Type' => 'application/json'})
      processor.processed_message.user.should == {'name' => 'Ben'}
    end

    context "when the user cannot be found" do
      before do
        stub_request(:get, 'http://internal:foobar@local.adamrabbit.com:3000/users/find_for_message.json')
          .with(query: {message: message.to_json})
          .to_return(status: 404, body: 'null', headers: {'Content-Type' => 'application/json'})
      end

      it "should set nil user data on the message" do
        processor.processed_message.user.should == nil
      end
    end

    context "specifying the memory URL" do
      before :each do
        ENV['ADAM_MEMORY_URL'] = 'http://test.com/memory'
      end

      after :all do
        ENV['ADAM_MEMORY_URL'] = 'http://local.adamrabbit.com:3000'
      end

      it "should allow specifying a URL with a namespace" do
        user = JSON.dump name: 'Ben'
        stub_request(:get, 'http://internal:foobar@test.com/memory/users/find_for_message.json')
          .with(query: {message: message.to_json})
          .to_return(body: user, headers: {'Content-Type' => 'application/json'})
        processor.processed_message.user.should == {'name' => 'Ben'}
      end
    end
  end
end
