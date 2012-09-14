$stdout.sync = true # Do not buffer stdout

require 'bundler/setup'

Bundler.require
require 'blather/client/dsl'
require 'json'

require_relative 'lib/xmpp_handler'
require_relative 'lib/amqp_handler'

AMQP.logging = true
Blather.logger.level = Logger::DEBUG if ENV['ADAM_FINGERS_DEBUG']

xmpp = XMPPHandler.new
xmpp.setup ENV['ADAM_FINGERS_JID'], ENV['ADAM_FINGERS_PASSWORD']

amqp = AMQPHandler.new "amqp://#{ENV['ADAM_FINGERS_AMQP_USERNAME']}:#{ENV['ADAM_FINGERS_AMQP_PASSWORD']}@#{ENV['ADAM_FINGERS_AMQP_HOST']}"

EM.run do
  xmpp.run amqp
  amqp.run xmpp

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

  amqp.work_queue 'message' do |payload|
    puts "Message was received: #{Message.from_json(payload)}"
    MessageHandler.new(Message.from_json(payload)).handle { |r| amqp.default_publish 'response', r.to_json }
  end

  amqp.work_queue 'response' do |payload|
    puts "Response was received: #{Response.from_json(payload)}"
    xmpp.process_message_response Response.from_json(payload)
  end
end
