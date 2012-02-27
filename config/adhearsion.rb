# Centralized way to overwrite any Adhearsion platform or plugin configuration
# - Execute rake adhearsion:config:desc to get the configuration options
# - Execute rake adhearsion:config:show to get the configuration values
#
# To update a plugin configuration you can write either:
#
#    * Option 1
#        Adhearsion.config.<plugin-name> do |config|
#          config.<key> = <value>
#        end
#
#    * Option 2
#        Adhearsion.config do |config|
#          config.<plugin-name>.<key> = <value>
#        end

Adhearsion.config do |config|
  # The Airbrake/Errbit API key [AHN_REPORTER_API_KEY]
  config.reporter.api_key = "68cd5fc4331903ace2d33b372339b38a"

  # Base URL for notification service [AHN_REPORTER_URL]
  config.reporter.url     = "http://errbit.mojolingo.com"

end

StatusMessages.setup "arabbit", Adhearsion.config.punchblock['password']

Adhearsion.router do
  # TODO: DOCUMENT THIS USAGE!!!
  route 'Mojo Lingo Extensions', ExtensionController, lambda {|call| call.variables[:to] =~ /^<sip:\d+@/ }

  route 'default' do
    answer
    speak "Hi, this is Adam, but you can call me Mr Rabbit. I don't really do much yet, but it's nice to meet you anyway! Bye!"
    hangup
  end
end

Adhearsion::XMPP.register_handlers do
  when_ready do
    client.write(Blather::Stanza::Presence::MUC.new.tap do |j|
      j.to = "internal-discuss@conference.mojolingo.com/arabbit"
    end)
  end

  subscription :request? do |s|
    if s.from.domain =~ /mojolingo\.(com|net)/
      logger.info "Approving XMPP subscription for #{s.from}"
      client.write s.approve!
    end
  end

  message [:chat?, :groupchat?], :body, :delay => nil do |m|
    response = MessageHandler.respond_to m
    client.write response unless response.nil?
  end

  muc_user :invite?, :from => /@conference.mojolingo.com/ do |muc_user|
    logger.info "Received an invite to #{muc_user.from} from #{muc_user.invite.from} with reason #{muc_user.invite.reason}."
    client.write(Blather::Stanza::Presence::MUC.new.tap do |j|
      j.to = [muc_user.from, 'arabbit'].join '/'
    end)
  end
end
