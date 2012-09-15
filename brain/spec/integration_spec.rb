require 'spec_helper'
require 'evented-spec'
require_relative '../lib/amqp_handler'

describe "AMQP handling" do
  include EventedSpec::AMQPSpec

  default_options host: 'adam.local', vhost: '/test'

  it "should respond to messages on the 'message' queue by publishing matching responses on the 'response' queue" do
    channel = AMQP::Channel.new

    AMQPHandler.new.listen

    responses = []
    channel.queue('response', auto_delete: true).subscribe { |p| responses << p }

    message = AdamCommon::Message.new source_type: :xmpp,
                source_address: 'foo@bar.com',
                body: "Hello"
    channel.default_exchange.publish message.to_json, routing_key: 'message'

    done 1 do
      expected_response = AdamCommon::Response.new target_type: :xmpp,
                            target_address: 'foo@bar.com',
                            body: 'Why hello there!'
      responses.should eql([expected_response.to_json])
    end
  end
end
