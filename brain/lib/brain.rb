require_relative 'hello_neuron'
require_relative 'failure_neuron'

class Brain
  def initialize
    @neurons = [FailureNeuron.new]
    add_neuron HelloNeuron.new
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
  # Add a neuron to the brain. Should follow the standard Neuron API:
  #
  # #confidence(message) should return a fixnum indicating neuron's confidence that it can handle the message appropriately
  # #reply(message) should return a string indicating the neuron's response to be forwarded to the user
  #
  def add_neuron(neuron)
    @neurons.insert -2, neuron
  end

  private

  def response(message)
    AdamCommon::Response.new target_type: message.source_type, target_address: message.source_address, body: response_body(message)
  end

  #
  # Retrieve the body of any response from the best matching neuron for
  #
  def response_body(message)
    matching_neurons_for_message(message).last.reply(message)
  end

  #
  # Sort neurons by their confidence in matching a message, with least confident first
  #
  def matching_neurons_for_message(message)
    @neurons.map { |neuron| [neuron, neuron.confidence(message)] }
      .sort { |(_,c1), (_,c2)| c1 <=> c2 }
      .map { |neuron, confidence| neuron }
  end
end
