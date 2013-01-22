require 'spec_helper'

require_relative '../../lib/translator_neuron'

describe TranslatorNeuron do
  include NeuronMatchers

  its(:translator) { should be_a BingTranslator }

  context "requesting translation" do
    before do
      subject.translator.should_receive(:translate).with('yes please', to: 'pt').and_return('Sim por favor')
    end

    [
      ['How do I say "yes please" in Portuguese?', '"Sim por favor"']
    ].each do |message_body, response|
      it { should handle_message(message_body).with_confidence(1).and_respond_with(response) }
    end
  end

  context "invalid messages" do
    [nil, 'foo', 'highlight'].each do |message_body|
      it { should handle_message(message_body).with_confidence(0) }
    end
  end
end
