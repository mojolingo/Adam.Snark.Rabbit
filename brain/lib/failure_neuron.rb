class FailureNeuron
  def intent
    'failure'
  end

  def reply(message, interpretation)
    {body: "Sorry, I don't understand."}
  end
end
