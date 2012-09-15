class Brain
  def initialize
    @neurons = []
    add_neuron do |message|
      "Why hello there!" if message.body =~ /hello|hi/i
    end
  end

  def handle(message)
    yield response(message)
  end

  def add_neuron(&block)
    @neurons << block
  end

  private

  def response(message)
    AdamCommon::Response.new target_type: message.source_type, target_address: message.source_address, body: response_body(message)
  end

  def response_body(message)
    body = nil
    @neurons.find { |neuron| body = neuron.call message }
    body ||= "Sorry, I don't understand."
  end
end
