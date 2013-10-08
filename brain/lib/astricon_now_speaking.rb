require 'date'
require_relative './astricon_presentations'

class AstriconNowSpeaking
  def intent
    'astricon_now_speaking'
  end

  def reply(message, interpretation)
    entities = interpretation['outcome']['entities']
    datetime = if entities.has_key? 'datetime'
      begin
        if entities['datetime']['value'].is_a? Hash
          DateTime.parse entities['datetime']['value']['from']
        else
          # One last attempt to parse the time
          DateTime.parse entities['datetime']['value']
        end
      rescue TypeError, ArgumentError
        return "Sorry, I don't understand what time you mean?"
      end
    else
      DateTime.now
    end
    sessions = AstriconPresentations.find_by_time datetime

    if sessions.count > 0
      message = "There are #{sessions.count} sessions on: "
      sessions.each do |name, data|
        message << "#{name} with #{data[:speakers].join ", "}; "
      end
    else
      message = "I don't see any presentations."
    end
    message
  end
end
