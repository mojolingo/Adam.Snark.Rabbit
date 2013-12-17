require 'spec_helper'
require 'timecop'

require_relative '../../lib/time_neuron'

describe TimeNeuron do
  include NeuronMatchers

  before { Timecop.freeze Time.local(2013, 10, 9, 8, 7, 6) }

  it { should handle_message(nil).and_respond_with(body: 'The time is  8:07 AM') }
end

