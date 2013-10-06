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

    it "should handle a properly formed request" do
      interpretation = wit_response_for 'How do I say "yes please" in Portuguese?', 'phrase_to_translate' => 'yes please', 'language' => 'Portuguese'
      should handle_message(message_body, :default_user, interpretation).and_respond_with('Sim por favor')
    end

    it "should handle an untranslateable target language" do
      message_body = 'How do I say "yes please" in Afrikaans?'
      interpretation = wit_response_for message_body, 'phrase_to_translate' => 'yes please', 'language' => 'Afrikaans'
      should handle_message(message_body, :default_user, interpretation).and_respond_with("Sorry, I don't speak Afrikaans.")
    end

    it "should handle an invalid target language" do
      message_body = 'How do I say "yes please" in klingon?'
      interpretation = wit_response_for message_body, 'phrase_to_translate' => 'yes please', 'language' => 'Klingon'
      should handle_message(message_body, :default_user, interpretation).and_respond_with("Sorry, I don't speak Klingon.")
    end
  end

  context "invalid messages" do
    [nil, 'foo', 'highlight'].each do |message_body|
      it { should handle_message(message_body, :default_user, wit_response_for(message_body)) }
    end
  end
end
