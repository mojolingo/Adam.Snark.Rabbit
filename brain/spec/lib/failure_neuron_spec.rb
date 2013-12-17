require 'spec_helper'

require_relative '../../lib/failure_neuron'

describe FailureNeuron do
  include NeuronMatchers

  it { should handle_message(nil).and_respond_with(body: "Sorry, I don't understand.") }
end
