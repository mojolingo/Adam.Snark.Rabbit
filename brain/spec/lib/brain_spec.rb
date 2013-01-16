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
          def confidence(message)
            message.body =~ /foo/ ? 1 : 0
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
    end

    context "when multiple neurons have some confidence they will match a single message" do
      let :neuron_class_1 do
        Class.new do
          def confidence(message)
            message.body =~ /foo/ ? 0.5 : 0
          end

          def reply(message)
            "Foo one"
          end
        end
      end

      let :neuron_class_2 do
        Class.new do
          def confidence(message)
            message.body =~ /foo/ ? 0.8 : 0
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

      it "invokes the neuron with the higher confidence" do
        response = nil
        subject.handle(message) { |r| response = r }
        response.should == response_with_body("Foo two")
      end
    end
  end
end
