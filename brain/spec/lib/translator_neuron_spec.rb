require 'spec_helper'

require_relative '../../lib/translator_neuron'

describe TranslatorNeuron do
  include NeuronMatchers

  its(:translator) { should be_a BingTranslator }

  context "requesting translation" do
    let(:phrase_to_translate) { 'yes please' }
    before do
      subject.translator.stub(:translate).with('yes please', to: 'pt').and_return('Sim por favor')
      subject.translator.stub(:translate).with('yes please', to: 'af').and_raise(Nokogiri::XML::XPath::SyntaxError)
    end

    it "should handle a properly formed request" do
      message_body = 'How do I say "yes please" in Portuguese?'
      interpretation = wit_interpretation message_body, 'translation', 'phrase_to_translate' => phrase_to_translate, 'language' => 'Portuguese'
      should handle_message(message_body, :default_user, interpretation).and_respond_with('Sim por favor')
    end

    it "should handle an untranslateable target language" do
      message_body = 'How do I say "yes please" in Afrikaans?'
      interpretation = wit_interpretation message_body, 'translation', 'phrase_to_translate' => phrase_to_translate, 'language' => 'Afrikaans'
      should handle_message(message_body, :default_user, interpretation).and_respond_with("Sorry, I don't speak Afrikaans.")
    end

    it "should handle an invalid target language" do
      message_body = 'How do I say "yes please" in klingon?'
      interpretation = wit_interpretation message_body, 'translation', 'phrase_to_translate' => phrase_to_translate, 'language' => 'Klingon'
      should handle_message(message_body, :default_user, interpretation).and_respond_with("Sorry, I don't speak Klingon.")
    end
  end

  context "invalid messages" do
    [nil, 'foo', 'highlight'].each do |message_body|
      it { should handle_message(message_body, :default_user, wit_interpretation(message_body, 'translation')) }
    end
  end
end
