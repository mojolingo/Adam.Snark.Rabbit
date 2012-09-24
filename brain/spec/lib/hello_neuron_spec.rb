require 'spec_helper'

require_relative '../../lib/hello_neuron'

describe HelloNeuron do
  ['Hello', 'hello', 'Hi', 'hi', 'Hi Adam'].each do |message_body|
    it "should be completely confident of matching #{message_body}" do
      message = AdamCommon::Message.new source_type: :xmpp,
                                        source_address: 'foo@bar.com',
                                        body: message_body
      subject.confidence(message).should be 1
    end
  end

  [nil, 'foo', 'highlight'].each do |message_body|
    it "should have zero confidence in matching #{message_body}" do
      message = AdamCommon::Message.new source_type: :xmpp,
                                        source_address: 'foo@bar.com',
                                        body: message_body
      subject.confidence(message).should be 0
    end
  end

  it "should always respond with 'Why hello there!'" do
    subject.reply(nil).should == "Why hello there!"
  end
end
