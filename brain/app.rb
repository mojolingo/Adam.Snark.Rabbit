$stdout.sync = true # Do not buffer stdout

require 'bundler/setup'

Bundler.require

require_relative 'lib/message_handler'

EM.run do
  AMQP.connect "amqp://#{ENV['ADAM_BRAIN_AMQP_USERNAME']}:#{ENV['ADAM_BRAIN_AMQP_PASSWORD']}@#{ENV['ADAM_BRAIN_AMQP_HOST']}" do |connection|
    channel = AMQP::Channel.new connection

    channel.queue('message', auto_delete: true).subscribe do |payload|
      puts "Message was received: #{AdamCommon::Message.from_json(payload)}"
      MessageHandler.new(AdamCommon::Message.from_json(payload)).handle do |r|
        puts "Sending response #{r}"
        channel.default_exchange.publish r.to_json, routing_key: 'response'
      end
    end
  end
end
