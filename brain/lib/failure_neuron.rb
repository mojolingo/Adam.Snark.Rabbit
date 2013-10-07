class FailureNeuron
  def intent
    'failure'
  end

  def confidence(message)
    0.2
  end

  def reply(message, interpretation)
    "Sorry, I don't understand."
  end
end
