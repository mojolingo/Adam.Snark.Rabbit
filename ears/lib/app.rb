require 'json'

require_relative 'amqp_handler'

AMQP.logging = true

class App < Adhearsion::Plugin
  run(:ears) do
    logger.info "Connecting to ATT speech API...."
    ATTSpeech.supervise_as :att_speech, ENV['ATT_ASR_KEY'], ENV['ATT_ASR_SECRET'], 'SPEECH'

    boot
  end

  def self.boot
    m = Mutex.new
    blocker = ConditionVariable.new

    Adhearsion::Events.amqp_connected do
      Adhearsion::Process.booted
      m.synchronize { blocker.broadcast }
    end

    Adhearsion::Events.shutdown do
      logger.info "Shutting down while connecting. Breaking the connection block."
      m.synchronize { blocker.broadcast }
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

  def self.publish_message(message, call_uri)
    message = AdamCommon::Message.new(body: message, source_address: call_uri, auth_address: 'demo@adamrabbit.net', source_type: :phone)
    logger.info "Publishing message #{message}"
    EM.next_tick { @amqp_handler.default_publish 'message', message.to_json }
  end

  def self.run
    EM.run do
      logger.info "Connecting to AMQP"
      @amqp_handler = amqp = AMQPHandler.new "amqp://#{ENV['ADAM_EARS_AMQP_USERNAME']}:#{ENV['ADAM_EARS_AMQP_PASSWORD']}@#{ENV['ADAM_EARS_AMQP_HOST']}"
      amqp.run
      amqp.work_queue 'response.phone' do |payload|
        response = AdamCommon::Response.from_json(payload)
        call = Adhearsion.active_calls[response.target_address]
        logger.info "Response was received: #{response} for #{call}"
        call.execute_controller do
          say response.body
          hangup
        end
      end
      logger.info "Connected and listening for messages"
      Adhearsion::Events.trigger :amqp_connected
    end
  end
end
