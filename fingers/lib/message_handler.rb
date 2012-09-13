class MessageHandler
  def initialize(message)
    @message = message
  end

  def response
    @response ||= "Why hello there!"
  end

  def handle
    yield @message, response
  end
end
