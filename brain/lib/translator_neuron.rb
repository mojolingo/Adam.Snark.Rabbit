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
    code = ISO_639.find_by_english_name match[:language]
    translation = translator.translate match[:phrase], to: code.alpha2
    translation.inspect
  end
end
