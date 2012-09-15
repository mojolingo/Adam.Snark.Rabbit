require_relative 'brain'

class AMQPHandler
  def initialize(brain = Brain.new)
    @channel = AMQP::Channel.new
    @brain = brain
  end

  def listen
    message_queue.subscribe &method(:handle_message)
  end

  def handle_message(payload)
    message = AdamCommon::Message.from_json payload
    puts "Message was received: #{message}"
    @brain.handle message do |r|
      puts "Sending response #{r}"
      publish_response r
    end
  end

  private

  def message_queue
    @channel.queue 'message', auto_delete: true
  end

  def publish_response(response)
    @channel.default_exchange.publish response.to_json, routing_key: 'response'
  end
end
