class WitActionNeuron
  REGEX = /\[action\](.*)/.freeze

  def intent
    'wit_action'
  end

  def reply(message, interpretation)
    match = interpretation['outcome']['intent'].match(REGEX)
    action = match[1]
    {action: action}
  end
end
