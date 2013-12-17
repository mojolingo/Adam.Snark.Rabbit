class WitActionNeuron
  REGEX = /_action_(?<action>.*)/.freeze

  def self.matching_intent?(intent)
    !! intent.match(REGEX)
  end

  def intent
    'wit_action'
  end

  def reply(message, interpretation)
    action = matching_action interpretation['outcome']['intent']
    {action: action}
  end

  private

  def matching_action(intent)
    intent.match(REGEX)[:action]
  end
end
