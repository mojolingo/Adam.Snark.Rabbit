require 'spec_helper'

require_relative '../../lib/translator_neuron'

describe TranslatorNeuron do
  include NeuronMatchers

  its(:translator) { should be_a BingTranslator }

  context "requesting translation" do
    before do
      subject.translator.stub(:translate).with('yes please', to: 'pt').and_return('Sim por favor')
      subject.translator.stub(:translate).with('yes please', to: 'af').and_raise(Nokogiri::XML::XPath::SyntaxError)
    end

    [
      ['How do I say "yes please" in Portuguese?', 'Sim por favor'],
      ['How do I say \'yes please\' in Portuguese?', 'Sim por favor'],
      ['How do I say yes please in Portuguese?', 'Sim por favor'],
      ['How do you say "yes please" in Portuguese?', 'Sim por favor'],
      ['What is "yes please" in Portuguese?', 'Sim por favor'],
      ['What\'s "yes please" in Portuguese?', 'Sim por favor'],
      ['How do I say "yes please" in Portuguese?', 'Sim por favor'],
      ['How do I say "yes please" in portuguese?', 'Sim por favor'], # Lower case target language
    ].each do |message_body, response|
      it do
        message = wit_response_for message_body, 'phrase_to_translate' => 'yes please', 'language' => 'Portuguese'
        should handle_message(message).and_respond_with(response)
      end
    end

      it "should handle an untranslateable target language" do
        message = wit_response_for 'How do I say "yes please" in Afrikaans?', 'phrase_to_translate' => 'yes please', 'language' => 'Afrikaans'
        should handle_message(message).and_respond_with("Sorry, I don't speak Afrikaans.")
      end

      it "should handle an invalid target language" do
        message = wit_response_for 'How do I say "yes please" in klingon?', 'phrase_to_translate' => 'yes please', 'language' => 'Klingon'
        should handle_message(message).and_respond_with("Sorry, I don't speak Klingon.")
      end
  end

  context "invalid messages" do
    [nil, 'foo', 'highlight'].each do |message_body|
      it { should handle_message(message_body) }
    end
  end
end
