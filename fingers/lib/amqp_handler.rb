class AMQPHandler
  def initialize(uri)
    @uri = uri
  end

  def run(xmpp_handler)
    @xmpp_handler = xmpp_handler

    connection  = AMQP.connect @uri
    @channel    = AMQP::Channel.new connection
  end

  def work_queue(queue_name, &block)
    queue = @channel.queue queue_name, auto_delete: true
    queue.subscribe &block
  end

  def work_topic(topic, routing_key, &block)
    @channel.queue("", exclusive: true, auto_delete: true) do |queue|
      queue.bind(@channel.topic(topic), routing_key: routing_key).subscribe &block
    end
  end

  def publish_message(payload)
    @channel.topic('messages').publish payload
  end
end
