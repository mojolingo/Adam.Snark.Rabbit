$stdout.sync = true # Do not buffer stdout

require 'bundler/setup'

Bundler.require

require_relative 'lib/amqp_handler'

require_relative 'lib/hello_neuron'

brain = Brain.new

brain.add_neuron HelloNeuron.new

EM.run do
  AMQP.connect "amqp://#{ENV['ADAM_BRAIN_AMQP_USERNAME']}:#{ENV['ADAM_BRAIN_AMQP_PASSWORD']}@#{ENV['ADAM_BRAIN_AMQP_HOST']}" do |connection|
    AMQPHandler.new(brain).listen
    puts "Connected and listening for messages"
  end
end
