require 'spec_helper'

require_relative '../../lib/failure_neuron'

describe FailureNeuron do
  include NeuronMatchers

  it { should handle_message(nil).with_confidence(0.2).and_respond_with("Sorry, I don't understand.") }
end
