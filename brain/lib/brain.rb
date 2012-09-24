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
  # Add a neuron to the brain. Should follow the standard Neuron API.
  #
  def add_neuron(neuron)
    @neurons.insert -2, neuron
  end

  private

  def response(message)
    AdamCommon::Response.new target_type: message.source_type, target_address: message.source_address, body: response_body(message)
  end

  def response_body(message)
    matching_neuron_for_message(message).reply(message)
  end

  def matching_neuron_for_message(message)
    @neurons.find { |neuron| neuron.confidence(message) == 1 }
  end
end
