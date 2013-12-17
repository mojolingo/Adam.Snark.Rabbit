require 'spec_helper'

require_relative '../../lib/brain'

describe Brain do
  include WitMessages

  let(:message_body) { "Hello" }
  let :message do
    AdamSignals::Message.new source_type: :xmpp,
                source_address: 'foo@bar.com',
                body: message_body
  end

  def response_with_body(body)
    AdamSignals::Response.new target_type: :xmpp,
                target_address: 'foo@bar.com',
                body: body
  end

  def response_with_action(action)
    AdamSignals::Response.new target_type: :xmpp,
                target_address: 'foo@bar.com',
                action: action
  end

  describe "handling a message" do
    before { Wit.stub query: interpretation }

    context "with a message that we don't understand" do
      let(:message_body) { "Lorem ipsum" }
      let(:interpretation) { wit_interpretation(message_body, 'random_intent') }

      it "should yield a message indicating lack of understanding" do
        response = nil
        subject.handle(message) { |r| response = r }
        response.should == response_with_body("Sorry, I don't understand.")
      end

      context "when wit signals an action" do
        let(:interpretation) { wit_interpretation(message_body, '_action_something') }

        it "should yield a message with an empty body, and copy the action token" do
          response = nil
          subject.handle(message) { |r| response = r }
          response.should == response_with_action('something')
        end
      end
    end

    context "with a custom neuron defined" do
      let :neuron_class do
        Class.new do
          def intent
            'foo'
          end

          def reply(message, interpretation)
            {body: "Foo to you too"}
          end
        end
      end

      let(:interpretation) { wit_interpretation(message_body, 'foo') }

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
            def intent
              'error_thrower'
            end

            def reply(message, interpretation)
              raise
            end
          end
        end

        let(:interpretation) { wit_interpretation(message_body, 'error_thrower') }

        it "should return a failure response message" do
          response = nil
          subject.handle(message) { |r| response = r }
          response.should == response_with_body("Sorry, I encountered a RuntimeError")
        end
      end
    end

    context "when multiple neurons are available"  do
      let :neuron_class_1 do
        Class.new do
          def intent
            'foo1'
          end

          def reply(message, interpretation)
            {body: "Foo one"}
          end
        end
      end

      let :neuron_class_2 do
        Class.new do
          def intent
            'foo2'
          end

          def reply(message, interpretation)
            {body: "Foo two"}
          end
        end
      end

      before do
        subject.add_neuron neuron_class_1.new
        subject.add_neuron neuron_class_2.new
      end

      let(:message_body) { 'foo' }
      let(:interpretation) { wit_interpretation(message_body, 'foo2') }

      it "invokes the neuron selected by Wit" do
        response = nil
        subject.handle(message) { |r| response = r }
        response.should == response_with_body("Foo two")
      end
    end
  end
end
