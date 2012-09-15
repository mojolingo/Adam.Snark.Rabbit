$stdout.sync = true # Do not buffer stdout

require 'bundler/setup'

Bundler.require

require_relative 'lib/amqp_handler'

EM.run do
  AMQP.connect "amqp://#{ENV['ADAM_BRAIN_AMQP_USERNAME']}:#{ENV['ADAM_BRAIN_AMQP_PASSWORD']}@#{ENV['ADAM_BRAIN_AMQP_HOST']}" do |connection|
    AMQPHandler.new.listen
  end
end
