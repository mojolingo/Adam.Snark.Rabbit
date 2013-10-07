require 'spec_helper'
require 'evented-spec'
require_relative '../lib/amqp_handler'
require_relative '../lib/greetings_neuron'

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

  def wit_interpretation(message, intent, entities = {})
    wit_entities = {}
    entities.keys.each do |key|
      wit_entities[key] = {'value' => entities[key], 'body' => entities[key]}
    end
    {
      "msg_id" => "7e7cf9a2-007d-499e-83db-49b1d0490141",
      "msg_body" => message,
      "outcome" => {
        "intent" => intent,
        "entities" => wit_entities,
        "confidence" => 0.57
      }
    }
  end

  let(:message_body) { 'foo' }
  let(:intent) { 'foo' }
  let(:entities) { {} }

  before do
    user = JSON.dump name: 'Ben'
    stub_request(:get, 'http://internal:foobar@local.adamrabbit.com/users/find_for_message.json')
      .with(query: hash_including)
      .to_return(body: user, headers: {'Content-Type' => 'application/json'})
    stub_request(:get, "https://api.wit.ai/message?q=#{message_body}")
      .to_return(body: wit_interpretation(message_body, intent, entities), headers: {'Content-Type' => 'application/json'})
  end

  it "should respond to messages on the 'message' queue by publishing matching responses on the 'response' queue" do
    channel = AMQP::Channel.new

    AMQPHandler.new.listen

    responses = []
    channel.queue('response', auto_delete: true).subscribe { |p| responses << p }

    publish_message channel, 'foo@bar.com', 'Hello'

    done 1 do
      expected_response = response :xmpp, 'foo@bar.com', "Sorry, I don't understand."
      responses.should eql([expected_response.to_json])
    end
  end

  context "with a custom neuron defined" do
    let :neuron_class do
      Class.new do
        def intent
          'foo'
        end

        def reply(message, interpretation)
          "Foo to you too"
        end
      end
    end

    before do
      brain.add_neuron GreetingsNeuron.new
      brain.add_neuron neuron_class.new
    end

    it "should respond to messages on the 'message' queue by publishing matching responses on the 'response' queue" do
      # Extra request to Wit
      stub_request(:get, "https://api.wit.ai/message?q=Hello")
        .to_return(body: wit_interpretation('Hello', 'greetings', entities), headers: {'Content-Type' => 'application/json'})
      stub_request(:get, "https://api.wit.ai/message?q=foo")
        .to_return(body: wit_interpretation('foo', 'foo', entities), headers: {'Content-Type' => 'application/json'})
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

    context "to check user data" do
      let :neuron_class do
        Class.new do
          def intent
            'name'
          end

          def reply(message, interpretation)
            message.user['name']
          end
        end
      end
      let(:message_body) { 'doodah' }
      let(:intent) { 'name' }

      before do
        brain.add_neuron neuron_class.new
      end

      it "should check that user data is fetched correctly" do
        channel = AMQP::Channel.new

        AMQPHandler.new(brain).listen

        responses = []
        channel.queue('response', auto_delete: true).subscribe { |p| responses << p }

        publish_message channel, 'foo@bar.com', message_body

        done 1 do
          expected_responses = [
            response(:xmpp, 'foo@bar.com', 'Ben')
          ]
          responses.should eql(expected_responses.map(&:to_json))
        end
      end
    end
  end
end
