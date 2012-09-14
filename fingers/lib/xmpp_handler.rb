require_relative 'message'
require_relative 'message_handler'

class XMPPHandler
  include Blather::DSL

  def initialize
    super
    subscription :request? do |s|
      write_to_stream s.approve!
    end

    message :body do |m|
      send_typing m.from
      message = Message.new body: m.body, source_address: m.from, source_type: :xmpp
      MessageHandler.new(message).handle &method(:process_message_response)
    end
  end

  def run
    Blather.logger.info "Connecting as #{jid}"
    client.run
  end

  def send_typing(jid)
    message = Blather::Stanza::Message.new
    message.to = jid
    message.chat_state = :composing
    write_to_stream message
  end

  def process_message_response(message, response)
    EM.add_timer 0.5 do
      say message.respond_to, response
    end
  end

  def add_to_roster(jid)
    my_roster << jid
    subscribe jid
  end

  def remove_from_roster(jid)
    my_roster.remove jid
  end

  def subscribe(jid)
    presence = Blather::Stanza::Presence.new
    presence.to   = jid
    presence.type = :subscribe
    write_to_stream presence
  end
end
