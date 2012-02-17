class MessageHandler
  class << self
    def respond_to(message)
      reply = message.reply
      reply.body = case message.body
      when /^list projects/
        list_project_names message
      when /^get status/i
        get_status message
      when /^help/i
        help message
      else
        "Now you're not making any sense at all!"
      end
      reply
    end

    def help(message)
      <<-MSG
      Things you can ask me:
      get status [for username]
      list projects [for customer]
      help
      MSG
    end

    def get_status(message)
      username = message.body.match(/^get status for (\w+)/)[1] rescue nil
      response = username.nil? ? StatusMessages.timeline(:public, 1) : StatusMessages.last_status_for(username)
      case response.first
      when nil
        "No status updates found for #{username}"
      when Array
        # {"error"=>"No such user."} becomes ["error", "No such user."]
        response.has_key?('error') ? "Server reported an error: #{response['error']}" : "Unknown error processing this request."
      else
        status = response.first
        "@#{status['user']['screen_name']}: \"#{status['text']}\""
      end
    end

    def list_project_names(message)
      client =  message.body.match(/^list projects for (\w+)/)[1] rescue nil
      list = client.nil? ? Client.find(:all) : Client.where(name: client)
      response = list.collect do |c|
        c.projects.collect do |p|
          "#{p.name} (#{c.name})"
        end
      end.flatten.join("\n")
      response.empty? ? 'No matching projects found.' : response
    end
  end
end