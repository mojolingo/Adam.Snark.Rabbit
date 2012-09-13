$stdout.sync = true # Do not buffer stdout

require 'bundler/setup'

Bundler.require
require 'blather/client/dsl'
require 'json'

class XMPPHandler
  include Blather::DSL

  def initialize
    super
    subscription :request? do |s|
      write_to_stream s.approve!
    end
  end

  def run
    Blather.logger.info "Connecting as #{jid}"
    client.run
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

class AMQPHandler
  def initialize(uri)
    @uri = uri
  end

  def run
    connection  = AMQP.connect @uri
    @channel     = AMQP::Channel.new connection
  end

  def work_queue(queue_name, &block)
    queue = @channel.queue queue_name, auto_delete: true
    queue.subscribe &block
  end
end

AMQP.logging = true
Blather.logger.level = Logger::DEBUG if ENV['ADAM_XMPP_DEBUG']

xmpp = XMPPHandler.new
xmpp.setup ENV['ADAM_XMPP_JID'], ENV['ADAM_XMPP_PASSWORD']

amqp = AMQPHandler.new "amqp://#{ENV['ADAM_FINGERS_AMQP_USERNAME']}:#{ENV['ADAM_FINGERS_AMQP_PASSWORD']}@#{ENV['ADAM_FINGERS_AMQP_HOST']}"

EM.run do
  xmpp.run
  amqp.run

  amqp.work_queue 'jid.created' do |payload|
    payload = JSON.parse payload
    puts "JID was created: #{payload['jid']}. Adding to roster."
    xmpp.add_to_roster payload['jid']
  end

  amqp.work_queue 'jid.removed' do |payload|
    payload = JSON.parse payload
    puts "JID was removed: #{payload['jid']}. Removing from roster."
    xmpp.remove_from_roster payload['jid']
  end
end
