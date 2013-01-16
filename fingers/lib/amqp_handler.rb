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

  def default_publish(key, payload)
    @channel.default_exchange.publish payload, routing_key: key
  end
end
