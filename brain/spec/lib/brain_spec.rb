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
    context "with a message that we don't understand" do
      let(:message_body) { "Lorem ipsum" }

      it "should yield a message indicating lack of understanding" do
        response = nil
        subject.handle(message) { |r| response = r }
        response.should == response_with_body("Sorry, I don't understand.")
      end
    end

    context "with a custom neuron defined" do
      let :neuron_class do
        Class.new do
          def intent(message)
            'foo'
          end

          def reply(message)
            "Foo to you too"
          end
        end
      end

      before do
        subject.add_neuron neuron_class.new
      end

      let(:message_body) { 'foo' }

      it "should yield the message returned by the neuron" do
        response = nil
        subject.handle(message) { |r| response = r }
        response.should == response_with_body("Foo to you too")
      end

      context "when a neuron explodes" do
        let :neuron_class do
          Class.new do
            def intent(message)
              raise
            end

            def reply(message)
              raise
            end
          end
        end

        it "should return a failure response message" do
          response = nil
          subject.handle(message) { |r| response = r }
          response.should == response_with_body("Sorry, I encountered a RuntimeError")
        end
      end
    end

    context "when multiple neurons have some confidence they will match a single message" do
      let :neuron_class_1 do
        Class.new do
          def intent
            'foo1'
          end

          def reply(message)
            "Foo one"
          end
        end
      end

      let :neuron_class_2 do
        Class.new do
          def intent
            'foo2'
          end

          def reply(message)
            "Foo two"
          end
        end
      end

      before do
        subject.add_neuron neuron_class_1.new
        subject.add_neuron neuron_class_2.new
      end

      let(:message_body) { 'foo' }
      
      let(:wit_response) do
        {
          "msg_id": "d953bd6c-c620-4dae-a3fc-7634b4330073",
          "msg_body": "get me a foo 2"
          "outcome": {
            "intent": "foo2",
            "entities": {},
            "confidence": 0.6310633902098893
          }
        }
      end

      it "invokes the neuron selected by Wit" do
        Wit.should_receive(:query).once.with(message).and_return wit_response
        response = nil
        subject.handle(message) { |r| response = r }
        response.should == response_with_body("Foo two")
      end
    end
  end
end
