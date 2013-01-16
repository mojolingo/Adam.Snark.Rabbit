module NeuronMatchers
  class MessageMatcher
    def initialize(message)
      @message = if message.is_a?(AdamCommon::Message)
        message
      else
        AdamCommon::Message.new body: message
      end
      @expected_confidence = 1
    end

    def matches?(neuron)
      @neuron = neuron
      matching_confidence? && matching_response?
    end

    def with_confidence(confidence)
      @expected_confidence = confidence
      self
    end

    def and_respond_with(response)
      @expected_response = response
      self
    end

    def failure_message_for_should
      "expected neuron to handle #{@message} with #{@expected_confidence*100}% confidence".tap do |message|
        message << " and reply with '#{@expected_response}'" if should_match_response?
        message << " but confidence was #{actual_confidence*100}%" unless matching_confidence?
        message << " #{matching_confidence? ? 'but' : 'and'} reply was '#{actual_reply}'" unless matching_response?
      end
    end

    def description
      "handle #{@message} with #{@expected_confidence*100}% confidence".tap do |description|
        description << " and reply with '#{@expected_response}'" if should_match_response?
      end
    end

    private

    def matching_confidence?
      actual_confidence == @expected_confidence
    end

    def actual_confidence
      @actual_confidence ||= @neuron.confidence @message
    end

    def should_match_response?
      !!@expected_response
    end

    def matching_response?
      return true unless should_match_response?
      actual_reply == @expected_response
    end

    def actual_reply
      @actual_reply ||= @neuron.reply @message
    end
  end

  def handle_message(message)
    MessageMatcher.new message
  end
end
