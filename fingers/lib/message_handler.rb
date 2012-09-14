class MessageHandler
  def initialize(message)
    @message = message
  end

  def response
    @response ||= calculate_response
  end

  def handle
    yield @message, response
  end

  private

  def calculate_response
    case @message.body
    when /hello|hi/i
      "Why hello there!"
    else
      "Sorry, I don't understand."
    end
  end
end
