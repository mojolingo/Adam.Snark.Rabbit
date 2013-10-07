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

    def translation_interpretation(message_body, language)
      wit_interpretation message_body, 'translation', 'phrase_to_translate' => phrase_to_translate, 'language' => language
    end

    it "should handle a properly formed request" do
      message = 'How do I say "yes please" in Portuguese?'
      should handle_message(message, :default_user, translation_interpretation(message, 'Portuguese'))
        .and_respond_with('Sim por favor')
    end

    it "should handle an untranslateable target language" do
      message = 'How do I say "yes please" in Afrikaans?'
      should handle_message(message, :default_user, translation_interpretation(message, 'Afrikaans'))
        .and_respond_with("Sorry, I don't speak Afrikaans.")
    end

    it "should handle an invalid target language" do
      message = 'How do I say "yes please" in klingon?'
      should handle_message(message, :default_user, translation_interpretation(message, 'Klingon'))
        .and_respond_with("Sorry, I don't speak Klingon.")
    end
  end

  context "invalid messages" do
    [nil, 'foo', 'highlight'].each do |message_body|
      it { should handle_message(message_body, :default_user, wit_interpretation(message_body, 'translation')) }
    end
  end
end
