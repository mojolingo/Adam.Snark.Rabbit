require 'date'
require_relative './astricon_presentations'

class AstriconNowSpeaking
  def intent
    'astricon_now_speaking'
  end

  def response(message, interpretation)
    sessions = AstriconPresentations.find_by_time DateTime.now

    if sessions.count > 0
      message = "There are #{sessions.count} sessions on right now: "
      sessions.each do |name, data|
        message << "#{name} with #{data[:speakers].join ", "}; "
      end
    else
      message = "There are no sessions on right now. Try back later."
    end
    message
  end
end
