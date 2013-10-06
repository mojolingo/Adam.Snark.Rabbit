require_relative 'failure_neuron'

class Brain
  MIN_CONFIDENCE = 0.4
  DEFAULT_NEURON = 'failure'

  def initialize
    add_neuron FailureNeuron.new
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
    logger.info "Message was received: #{message}"
    reply = response message
    logger.info "Sending response #{reply}"
    yield reply
  end

  #
  # Add a neuron to the brain. Should follow the standard Neuron API:
  #
  # #reply(message) should return a string indicating the neuron's response to be forwarded to the user
  # #intent should return a string indicating a nickname for the neuron
  #
  def add_neuron(neuron)
    @neurons ||= {}
    @neurons[neuron.intent] = neuron
  end

  private

  def response(message)
    AdamCommon::Response.new target_type: message.source_type, target_address: message.source_address, body: response_body(message)
  end

  #
  # Retrieve the body of any response from the best matching neuron for
  #
  def response_body(message)
    interpretation = Wit.query message.body
    find_best_neuron(interpretation).reply(message, interpretation)
  rescue => e
    Adhearsion::Events.trigger :exception, [e, logger]
    "Sorry, I encountered a #{e.class}"
  end

  #
  # Find the most relevant neuron for a given message
  #
  def find_best_neuron(interpretation)
    intent, confidence = interpretation['outcome']['intent'], interpretation['outcome']['confidence']
    if confidence >= MIN_CONFIDENCE && @neurons.has_key?(intent)
      @neurons[intent]
    else
      @neurons[DEFAULT_NEURON]
    end
  end
end
