class TellJokeNeuron
  def intent
    'tell_joke'
  end

  def reply(message, interpretation)
    {body: [
      "A man walks into a bar.  Ouch",
      "Once upon a time there was. Oh. I forget the rest",
      "Are you sure you want a joke? I have a black belt in sarcasm. Ask me some other time.",
      "I never wanted to believe that my Dad was stealing from his job as a road worker. But when I got home, all the signs were there.",
      "Have you heard what Mozart is up to right now? Decomposing.",
      "I went to the bank the other day and asked the banker to check my balance, so she pushed me!",
      "A drunk walks into a bar with jumper cables around his neck. The bartender says, You can stay but don't try to start anything.",
      "What do you call a boomerang that doesn't come back? A stick.",
      "To the optimist, the glass is half full. To the pessimist, the glass is half empty. To the engineer, the glass is twice as big as it needs to be.",
      "A man is telling his neighbor, I just bought a new hearing aid. It cost me $4000, but it's state of the art. It is perfect. Really? answers the neighbor. What kind is it? The man replies, 12:30."
    ].sample }
  end
end
