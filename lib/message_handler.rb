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
      when Array
        # {"error"=>"No such user."} becomes ["error", "No such user."]
        response.has_key?('error') ? "Server reported an error: #{response['error']}" : "Unknown error processing this request."
      else
        "@#{username}: \"#{response.first['text']}\""
      end
      reply
    end
  end
end