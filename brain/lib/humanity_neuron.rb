class HumanityNeuron
  GREETING_MATCHER = /^(hello|hi)\b/i
  PLEASANTRY_MATCHER = /How are you?/i

  def confidence(message)
    case message.body
    when GREETING_MATCHER, PLEASANTRY_MATCHER
      1
    else
      0
    end
  end

  def reply(message)
    case message.body
    when GREETING_MATCHER
      "Why hello there!"
    when PLEASANTRY_MATCHER
      "I'm fine thanks."
    end
  end
end
