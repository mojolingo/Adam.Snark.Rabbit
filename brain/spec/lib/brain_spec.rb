require 'spec_helper'

require_relative '../../lib/brain'

describe Brain do
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

  describe "handling a message" do
    it "should yield the response to the passed block" do
      response = nil
      subject.handle(message) { |r| response = r }
      response.should == response_with_body("Why hello there!")
    end

    context "with a message that we don't understand" do
      let(:message_body) { "Lorem ipsum" }

      it "should yield a message indicating lack of understanding" do
        response = nil
        subject.handle(message) { |r| response = r }
        response.should == response_with_body("Sorry, I don't understand.")
      end
    end

    context "with a custom neuron defined" do
      before do
        subject.add_neuron do |message|
          if message.body =~ /foo/
            "Foo to you too"
          end
        end
      end

      let(:message_body) { 'foo' }

      it "should yield the message returned by the neuron" do
        response = nil
        subject.handle(message) { |r| response = r }
        response.should == response_with_body("Foo to you too")
      end
    end
  end
end
