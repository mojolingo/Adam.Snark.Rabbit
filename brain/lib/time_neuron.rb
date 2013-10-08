class TimeNeuron
  def intent
    'the_time'
  end

  def reply(message, interpretation)
    Time.now.strftime "The time is %l:%M %p"
  end
end
