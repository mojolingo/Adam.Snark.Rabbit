require_relative 'brain'
require_relative 'message_processor'

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
    message = processed_message message
    @brain.handle message do |r|
      publish_response r, message.source_type
    end
  end

  private

  def processed_message(message)
    MessageProcessor.new(message).processed_message
  end

  def message_queue
    @channel.queue 'message'
  end

  def publish_response(response, type)
    key = "response.#{type}"
    logger.debug "Publishing #{response} to #{key}"
    @channel.default_exchange.publish response.to_json, routing_key: key
  end
end
