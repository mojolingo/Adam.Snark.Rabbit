require 'spec_helper'

require_relative '../../lib/wit_action_neuron'

describe WitActionNeuron do
  include NeuronMatchers

  it { should handle_message('what?', :default_user, wit_interpretation('what?', '[action]something')).and_respond_with(action: 'something') }
end
