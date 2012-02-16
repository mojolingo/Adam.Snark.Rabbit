class MessageHandler
  class << self
    def respond_to(message)
      case message.body
      when /^get status/i
        get_status message
      end
    end

    def get_status(message)
      username = message.body.match(/^get status for (\w+)/)[1]
      response = StatusMessages.last_status_for username
      reply = message.reply
      reply.body = case response.first
      when nil
        "No status updates found for #{username}"
      else
        "@#{username}: \"#{response.first['text']}\""
      end
      reply
    end
  end
end