require 'spec_helper'

require_relative '../../lib/failure_neuron'

describe FailureNeuron do
  it "should have 20% confidence of matching any message" do
    subject.confidence(nil).should eq(0.2)
  end

  it "should always respond with 'Sorry, I don't understand.'" do
    subject.reply(nil).should == "Sorry, I don't understand."
  end
end
