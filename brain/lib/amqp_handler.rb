require_relative 'brain'
require_relative 'message_processor'

class AMQPHandler
  def initialize(connection, brain = Brain.new)
    @channel = AMQP::Channel.new connection
    @brain = brain
  end

  def listen
    @channel.queue("", exclusive: true, auto_delete: true) do |queue|
      queue.bind(@channel.topic("messages")).subscribe &method(:handle_message)
    end
  end

  def handle_message(headers, payload)
    message = AdamSignals::Message.from_json payload
    message = processed_message message
    @brain.handle message, &method(:publish_response)
  end

  private

  def processed_message(message)
    MessageProcessor.new(message).processed_message
  end

  def publish_response(response, type)
    key = "response.#{type}"
    logger.debug "Publishing #{response} to #{key}"
    @channel.topic('responses').publish response.to_json, routing_key: key
  end
end
