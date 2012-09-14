$stdout.sync = true # Do not buffer stdout

require 'bundler/setup'

Bundler.require

require_relative 'lib/amqp_handler'
require_relative 'lib/message_handler'

AMQP.logging = true

amqp = AMQPHandler.new "amqp://#{ENV['ADAM_BRAIN_AMQP_USERNAME']}:#{ENV['ADAM_BRAIN_AMQP_PASSWORD']}@#{ENV['ADAM_BRAIN_AMQP_HOST']}"

EM.run do
  amqp.run

  amqp.work_queue 'message' do |payload|
    puts "Message was received: #{AdamCommon::Message.from_json(payload)}"
    MessageHandler.new(AdamCommon::Message.from_json(payload)).handle do |r|
      puts "Sending response #{r}"
      amqp.default_publish 'response', r.to_json
    end
  end
end
