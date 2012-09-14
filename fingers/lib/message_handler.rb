require_relative 'response'

class MessageHandler
  def initialize(message)
    @message = message
  end

  def response
    @response ||= Response.new(target_type: @message.source_type, target_address: @message.source_address, body: response_body)
  end

  def handle
    yield response
  end

  private

  def response_body
    case @message.body
    when /hello|hi/i
      "Why hello there!"
    else
      "Sorry, I don't understand."
    end
  end
end
