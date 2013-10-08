class TimeNeuron
  def intent
    'the_time'
  end

  def response(message, interpretation)
    Time.now.strftime "The time is %l:%M %P"
  end
end
