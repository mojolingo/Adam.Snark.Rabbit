class TranslatorNeuron
  MATCHER = /How do I say "(?<phrase>.*)" in (?<language>.*)\?/i

  def translator
    @translator ||= BingTranslator.new(ENV['BING_TRANSLATE_KEY'], ENV['BING_TRANSLATE_SECRET'])
  end

  def confidence(message)
    MATCHER.match(message.body).nil? ? 0 : 1
  end

  def reply(message)
    match = MATCHER.match message.body
    language = match[:language].capitalize
    code = ISO_639.find_by_english_name language
    return "Sorry, I don't speak #{language}." unless code
    translation = translator.translate match[:phrase], to: code.alpha2
    translation.inspect
  rescue Nokogiri::XML::XPath::SyntaxError
    "Sorry, I don't speak #{language}."
  end
end
