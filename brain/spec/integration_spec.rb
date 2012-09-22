require 'spec_helper'
require 'evented-spec'
require_relative '../lib/amqp_handler'

describe "AMQP handling" do
  include EventedSpec::AMQPSpec

  default_options host: 'local.adamrabbit.net', vhost: '/test'

  let(:brain) { Brain.new }

  def publish_message(channel, from, body)
    message = AdamCommon::Message.new source_type: :xmpp,
                source_address: from, body: body
    channel.default_exchange.publish message.to_json, routing_key: 'message'
  end

  def response(type, address, body)
    AdamCommon::Response.new target_type: type,
                            target_address: address,
                            body: body
  end

  it "should respond to messages on the 'message' queue by publishing matching responses on the 'response' queue" do
    channel = AMQP::Channel.new

    AMQPHandler.new.listen

    responses = []
    channel.queue('response', auto_delete: true).subscribe { |p| responses << p }

    publish_message channel, 'foo@bar.com', 'Hello'

    done 1 do
      expected_response = response :xmpp, 'foo@bar.com', 'Why hello there!'
      responses.should eql([expected_response.to_json])
    end
  end

  context "with a custom neuron defined" do
    before do
      brain.add_neuron do |message|
        if message.body =~ /foo/
          "Foo to you too"
        end
      end
    end

    it "should respond to messages on the 'message' queue by publishing matching responses on the 'response' queue" do
      channel = AMQP::Channel.new

      AMQPHandler.new(brain).listen

      responses = []
      channel.queue('response', auto_delete: true).subscribe { |p| responses << p }

      publish_message channel, 'foo@bar.com', 'Hello'
      publish_message channel, 'foo@bar.com', 'foo'

      done 1 do
        expected_responses = [
          response(:xmpp, 'foo@bar.com', 'Why hello there!'),
          response(:xmpp, 'foo@bar.com', 'Foo to you too')
        ]
        responses.should eql(expected_responses.map(&:to_json))
      end
    end
  end
end
