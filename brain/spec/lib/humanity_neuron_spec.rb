require 'spec_helper'

require_relative '../../lib/humanity_neuron'

describe HumanityNeuron do
  include NeuronMatchers

  context "greetings" do
    [
      ['Hello', 'Why hello there!'],
      ['hello', 'Why hello there!'],
      ['Hi', 'Why hello there!'],
      ['hi', 'Why hello there!'],
      ['Hi Adam', 'Why hello there!']
    ].each do |message_body, response|
      it { should handle_message(message_body).with_confidence(1).and_respond_with(response) }
    end
  end

  context "pleasantries" do
    it { should handle_message('How are you?').with_confidence(1).and_respond_with("I'm fine thanks.") }
  end

  context "invalid messages" do
    [nil, 'foo', 'highlight', 'What is hello in French?'].each do |message_body|
      it { should handle_message(message_body).with_confidence(0) }
    end
  end
end
