class PleasantriesNeuron
  def intent
    'pleasantries'
  end

  def reply(message, interpretation)
    { body: ["I'm fine thanks.", "I am well today, thanks for asking", "Just fine", "It's a little cold today, but great otherwise", "Not bad, not bad at all"].sample }
  end
end
