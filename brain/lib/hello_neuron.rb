class HelloNeuron
  MATCHER = /(hello|hi)\b/i

  def confidence(message)
    message.body =~ MATCHER ? 1 : 0
  end

  def reply(message)
    "Why hello there!"
  end
end
