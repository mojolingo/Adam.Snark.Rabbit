require_relative 'brain'
require_relative 'amqp_handler'

require_relative 'greetings_neuron'
require_relative 'pleasantries_neuron'
require_relative 'translator_neuron'
require_relative 'contacts_neuron'
require_relative 'mirror_mirror_neuron'
require_relative 'time_neuron'
require_relative 'tell_joke_neuron'

class App < Adhearsion::Plugin
  init :brain do
    @brain = Brain.new

    @brain.add_neuron GreetingsNeuron.new
    @brain.add_neuron PleasantriesNeuron.new
    @brain.add_neuron TranslatorNeuron.new
    @brain.add_neuron ContactsNeuron.new
    @brain.add_neuron MirrorMirrorNeuron.new
    @brain.add_neuron TimeNeuron.new
    @brain.add_neuron TellJokeNeuron.new
  end

  run :brain do
    boot
  end

  def self.boot
    return unless Adhearsion::Process.state_name == :booting
    m = Mutex.new
    blocker = ConditionVariable.new

    Adhearsion::Events.amqp_connected do
      Adhearsion::Process.booted
      m.synchronize { blocker.broadcast }
    end

    Adhearsion::Events.shutdown do
      logger.info "Shutting down while connecting. Breaking the connection block."
      m.synchronize { blocker.broadcast }
      EM.next_tick { EM.stop }
    end

    Adhearsion::Process.important_threads << Thread.new do
      catching_standard_errors { connect_to_server }
    end

    # Wait for the connection to establish
    m.synchronize { blocker.wait m }
  end

  def self.connect_to_server
    run
  rescue => e
    # We only care about disconnects if the process is up or booting
    return unless [:booting, :running].include? Adhearsion::Process.state_name

    Adhearsion::Process.reset unless Adhearsion::Process.state_name == :booting

    logger.error e
    logger.fatal "AMQP connection failed. Going down."
    Adhearsion::Process.stop!
  end

  def self.run
    EM.run do
      AMQP.connect "amqp://#{ENV['ADAM_BRAIN_AMQP_USERNAME']}:#{ENV['ADAM_BRAIN_AMQP_PASSWORD']}@#{ENV['ADAM_BRAIN_AMQP_HOST']}" do |connection|
        AMQPHandler.new(connection, @brain).listen
        logger.info "Connected and listening for messages"
        Adhearsion::Events.trigger :amqp_connected
      end
    end
  end
end
