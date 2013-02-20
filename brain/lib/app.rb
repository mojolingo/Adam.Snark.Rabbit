require_relative 'brain'
require_relative 'amqp_handler'

require_relative 'humanity_neuron'
require_relative 'translator_neuron'
require_relative 'contacts_neuron'

class App < Adhearsion::Plugin
  init :brain do
    @brain = Brain.new

    @brain.add_neuron HumanityNeuron.new
    @brain.add_neuron TranslatorNeuron.new
    @brain.add_neuron ContactsNeuron.new
  end

  run :brain do
    Adhearsion::Process.important_threads << Thread.new do
      catching_standard_errors { boot }
    end
  end

  def self.boot
    EM.run do
      AMQP.connect "amqp://#{ENV['ADAM_BRAIN_AMQP_USERNAME']}:#{ENV['ADAM_BRAIN_AMQP_PASSWORD']}@#{ENV['ADAM_BRAIN_AMQP_HOST']}" do |connection|
        AMQPHandler.new(@brain).listen
        logger.info "Connected and listening for messages"
      end
    end
  end
end
