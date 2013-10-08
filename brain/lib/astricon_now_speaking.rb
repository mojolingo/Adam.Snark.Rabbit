require 'date'
require_relative './astricon_presentations'

class AstriconNowSpeaking
  def intent
    'astricon_now_speaking'
  end

  def response(message, interpretation)
    sessions = AstriconPresentations.find_by_time DateTime.now

    message = "There are #{sessions.count} sessions on right now: "
    sessions.each do |name, data|
      message << "#{name} with #{data[:speakers].join ", "}; "
    end
    message
  end
end
