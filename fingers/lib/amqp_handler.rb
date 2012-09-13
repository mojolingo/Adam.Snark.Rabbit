class AMQPHandler
  def initialize(uri)
    @uri = uri
  end

  def run
    connection  = AMQP.connect @uri
    @channel    = AMQP::Channel.new connection
  end

  def work_queue(queue_name, &block)
    queue = @channel.queue queue_name, auto_delete: true
    queue.subscribe &block
  end
end
