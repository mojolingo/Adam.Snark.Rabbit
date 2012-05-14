class MessageHandler
  ADDRESSED_TO_ME = /^arabbit: |^!/

  class << self
    def respond_to(message)

      if message.groupchat?
        return nil unless message.body =~ ADDRESSED_TO_ME
      end

      message.body = message.body.gsub ADDRESSED_TO_ME, ''

      reply = message.reply
      # Strip the resource off the "to" field, since it represents the sender of the original message
      reply.to = "#{reply.to.node}@#{reply.to.domain}" if message.groupchat?
      reply.body = case message.body
      when /^list projects/
        list_project_names message
      when /^get status/i
        get_status message
      when /^enter [\d\.]+(?:h| hours) for/i
        enter_time message
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
      enter <#.#> hours for <customer>: <description>
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

    def enter_time(message)
      # TODO: Need to look up the "real" JID from the Roster. Otherwise we'll post with the MUC JID, which is wrong!
      return "Sorry, this command does not work from groupchat. Send it to me directly." if message.from.to_s =~ /@conference.mojolingo.com/

      matches = message.body.match(/^enter ([\d\.]+)(?:h| hour[s]?) for ([\w\s]+): (.*)$/) || []
      hours, client_name, description = matches[1], matches[2], matches[3]

      return 'I could not process that request.  Please enter time in the format:
enter 2 hours for SampleClient: I fixed all their problems.' if (client_name.nil? || hours.nil? || description.nil?)

      client = Wisecrack.first_client_for_company client_name
      return "I could not find a client by that name: #{client_name}" if client.nil?

      Wisecrack.record_time :date         => Date.today,
                            :client       => client['id'],
                            :type         => 1,
                            :hours        => hours.to_f,
                            :description  => description,
                            :employee     => message.from.stripped.to_s

      "Time recorded. Get back to work!"
    rescue XMLRPC::FaultException => e
      "Error processing your time request: #{e.message}"
    end
  end
end
