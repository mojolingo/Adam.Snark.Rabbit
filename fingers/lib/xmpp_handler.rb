require 'blather/client/dsl'

class XMPPHandler
  include Blather::DSL

  def initialize
    super

    subscription :request? do |s|
      write_to_stream s.approve!
    end

    message :body do |m|
      EM.next_tick do
        send_typing m.from
        message = AdamCommon::Message.new(body: m.body, source_address: m.from.to_s, auth_address: m.from.to_s, source_type: :xmpp)
        logger.info "Publishing message #{message}"
        @amqp_handler.publish_message message.to_json
      end
    end
  end

  def run(amqp_handler)
    @amqp_handler = amqp_handler

    Blather.logger.info "Connecting as #{jid}"
    client.run
  end

  def send_typing(jid)
    message = Blather::Stanza::Message.new
    message.to = jid
    message.chat_state = :composing
    write_to_stream message
  end

  def process_message_response(response)
    say response.target_address, response.body
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
