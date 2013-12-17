class TranslatorNeuron
  def intent
    'translation'
  end

  def translator
    @translator ||= BingTranslator.new(ENV['BING_TRANSLATE_KEY'], ENV['BING_TRANSLATE_SECRET'])
  end

  def reply(message, interpretation)
    params = interpretation['outcome']['entities']
    language = params.has_key?('language') ? params['language']['value'] : nil
    return {body: "I can't translate that"} unless language
    code = ISO_639.find_by_english_name language
    return {body: "Sorry, I don't speak #{language}."} unless code
    phrase = params.has_key?('phrase_to_translate') ? params['phrase_to_translate']['value'] : nil
    return {body: "What did you want me to translate?"} unless phrase
    translation = translator.translate params['phrase_to_translate']['value'], to: code.alpha2
    {body: translation}
  rescue Nokogiri::XML::XPath::SyntaxError
    {body: "Sorry, I don't speak #{language}."}
  end
end
