class TranslatorNeuron
  def intent
    'translation'
  end

  def translator
    @translator ||= BingTranslator.new(ENV['BING_TRANSLATE_KEY'], ENV['BING_TRANSLATE_SECRET'])
  end

  def reply(message)
    params = message['outcome']['entities']
    language = params['language']['value']
    code = ISO_639.find_by_english_name language
    return "Sorry, I don't speak #{language}." unless code
    phrase = params['phrase_to_translate']['value']
    translation = translator.translate params['phrase_to_translate']['value'], to: code.alpha2
    translation.inspect
  rescue Nokogiri::XML::XPath::SyntaxError
    "Sorry, I don't speak #{language}."
  end
end
