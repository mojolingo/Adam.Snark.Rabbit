class Brain
  def initialize
    @neurons = []
    add_neuron do |message|
      "Why hello there!" if message.body =~ /hello|hi/i
    end
  end

  #
  # Handle a message received from a user
  #
  # @param [AdamCommon::Message] message received from the user
  #
  # @yield [response] handle the response calculated from the message
  # @yieldparam [AdamCommon::Response] response
  #
  def handle(message)
    yield response(message)
  end

  #
  # Add a neuron to the brain
  #
  # @yield [message] process an incoming message
  # @yieldparam [AdamCommon::Message] message the message received from a user
  # @yieldreturn [String, nil] a response body if the neuron can handle the message. Otherwise nil.
  #
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
