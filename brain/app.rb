$stdout.sync = true # Do not buffer stdout

require 'bundler/setup'

Bundler.require

require_relative 'lib/amqp_handler'

require_relative 'lib/humanity_neuron'
require_relative 'lib/translator_neuron'
require_relative 'lib/crm_neuron'

brain = Brain.new

brain.add_neuron HumanityNeuron.new
brain.add_neuron TranslatorNeuron.new
brain.add_neuron CRMNeuron.new

Logging.logger.root.appenders = [Logging.appenders.stdout('stdout')]
Logging.logger.root.level = :info

logger = Logging.logger(STDOUT)
logger.level = :info

EM.run do
  AMQP.connect "amqp://#{ENV['ADAM_BRAIN_AMQP_USERNAME']}:#{ENV['ADAM_BRAIN_AMQP_PASSWORD']}@#{ENV['ADAM_BRAIN_AMQP_HOST']}" do |connection|
    AMQPHandler.new(brain).listen
    logger.info "Connected and listening for messages"
  end
end
