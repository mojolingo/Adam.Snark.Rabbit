require_relative 'failure_neuron'
require_relative 'wit_action_neuron'

class Brain
  MIN_CONFIDENCE = 0.4
  DEFAULT_NEURON = 'failure'
  WIT_ACTION_NEURON = 'wit_action'

  def initialize
    add_neuron FailureNeuron.new
    add_neuron WitActionNeuron.new
  end

  #
  # Handle a message received from a user
  #
  # @param [AdamSignals::Message] message received from the user
  #
  # @yield [response, type] handle the response calculated from the message
  # @yieldparam [AdamSignals::Response] response
  # @yieldparam [Symbol] type The type of response. Can be :xmpp, :phone, etc. Used for routing the response to the best mode gateway.
  #
  def handle(message)
    logger.info "Message was received: #{message}"

    response_targets = {message.source_type => message.source_address}

    if message.source_type == :phone && message.user
      internal_jid = "#{message.user['id']}@#{ENV['ADAM_ROOT_DOMAIN'].sub(/:\d*/, '')}"
      response_targets[:xmpp] = internal_jid

      forward = response :xmpp, internal_jid, body: "You said #{message.body}."
      logger.info "Forwarding phone message to UI: #{forward}"
      yield forward, :xmpp
    end

    response_attributes = response_attributes message

    response_targets.each_pair do |type, address|
      reply = response type, address, response_attributes
      logger.info "Sending response #{reply}"
      yield reply, type
    end
  end

  #
  # Add a neuron to the brain. Should follow the standard Neuron API:
  #
  # #reply(message) should return a string indicating the neuron's response to be forwarded to the user
  # #intent should return a string indicating a nickname for the neuron
  #
  def add_neuron(neuron)
    @neurons ||= {}
    @neurons[neuron.intent] = neuron
  end

  private

  def response_targets(message)
    targets = {message.source_type => message.source_address}
    if message.source_type == :phone
      targets[:xmpp] = "#{message.user['id']}@#{ENV['ADAM_ROOT_DOMAIN'].sub(/:\d*/, '')}"
    end
    targets
  end

  def response(type, address, attributes = {})
    AdamSignals::Response.new({target_type: type, target_address: address}.merge(attributes))
  end

  #
  # Retrieve the attributes of any response from the best matching neuron for
  #
  def response_attributes(message)
    interpretation = Wit.query message.body
    logger.debug "Wit interpretation: #{interpretation.inspect}"
    reply = find_best_neuron(interpretation).reply(message, interpretation)
    if reply.is_a?(String)
      {body: reply}
    else
      reply
    end
  rescue => e
    Adhearsion::Events.trigger :exception, [e, logger]
    {body: "Sorry, I encountered a #{e.class}"}
  end

  #
  # Find the most relevant neuron for a given message
  #
  def find_best_neuron(interpretation)
    intent, confidence = interpretation['outcome']['intent'], interpretation['outcome']['confidence']
    if confidence >= MIN_CONFIDENCE && @neurons.has_key?(intent)
      @neurons[intent]
    elsif intent.match(WitActionNeuron::REGEX)
      @neurons[WIT_ACTION_NEURON]
    else
      @neurons[DEFAULT_NEURON]
    end
  end
end
