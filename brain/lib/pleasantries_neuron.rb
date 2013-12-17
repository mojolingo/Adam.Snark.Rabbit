class PleasantriesNeuron
  def intent
    'pleasantries'
  end

  def reply(message, interpretation)
    {body: "I'm fine thanks."}
  end
end
