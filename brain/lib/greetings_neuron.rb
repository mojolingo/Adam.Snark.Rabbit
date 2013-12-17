class GreetingsNeuron
  def intent
    'greetings'
  end

  def reply(message, interpretation)
    {body: "Why hello there!"}
  end
end
