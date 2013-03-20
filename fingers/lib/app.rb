require 'blather/client/dsl'
require 'json'

require_relative 'xmpp_handler'
require_relative 'amqp_handler'

AMQP.logging = true

class App < Adhearsion::Plugin
  run(:fingers) { boot }

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
    logger.fatal "AMQP/XMPP connection failed. Going down."
    Adhearsion::Process.stop!
  end

  def self.run
    xmpp = XMPPHandler.new
    xmpp.setup ENV['ADAM_FINGERS_JID'], ENV['ADAM_FINGERS_PASSWORD']

    Blather.logger = xmpp.logger

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

      amqp.work_queue 'response' do |payload|
        puts "Response was received: #{AdamCommon::Response.from_json(payload)}"
        xmpp.process_message_response AdamCommon::Response.from_json(payload)
      end

      logger.info "Connected and listening for messages"
    end
  end
end
