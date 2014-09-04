require 'blather/client/dsl'

require_relative 'brain'
require_relative 'message_processor'

class XMPPHandler
  include Blather::DSL

  def initialize(brain = Brain.new)
    @brain = brain

    super

    subscription :request? do |s|
      write_to_stream s.approve!
    end

    message :body, type: [nil, :chat, :normal] do |m|
      EM.next_tick do
        send_typing m.from
        handle_message AdamSignals::Message.new(body: m.body, source_address: m.from.to_s, auth_address: m.from.to_s, source_type: :xmpp)
      end
    end
  end

  def run
    Blather.logger.info "Connecting as #{jid}"
    client.run
  end

  def handle_message(message)
    logger.info "Handling message #{message}"
    catching_standard_errors do
      @brain.handle processed_message(message), &method(:publish_response)
    end
  end

  private

  def processed_message(message)
    MessageProcessor.new(message).processed_message
  end

  def publish_response(response, type)
    key = "response.#{type}"
    logger.debug "Publishing #{response} to #{key}"
    @channel.topic('responses').publish response.to_json, routing_key: key
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
