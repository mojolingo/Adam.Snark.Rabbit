require 'spec_helper'

require_relative '../../lib/failure_neuron'

describe FailureNeuron do
  it "should be completely confident of matching any message" do
    subject.confidence(nil).should be 1
  end

  it "should always respond with 'Sorry, I don't understand.'" do
    subject.reply(nil).should == "Sorry, I don't understand."
  end
end
