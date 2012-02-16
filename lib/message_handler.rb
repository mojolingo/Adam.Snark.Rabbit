class MessageHandler
  class << self
    def respond_to(message)
      case message.body
      when /^get status for/i
        get_status message
      end
    end

    def get_status(message)
      username = message.body.match(/^get status for (\w+)/)[1]
      status = StatusMessages.last_status_for username
      reply = message.reply
      reply.body = status.text
    end
  end
end