require 'spec_helper'

describe AMQPConnection do
  subject { AMQPConnection.instance }

  it "should have a bunny targeted at the AMQP server and connected" do
    subject.bunny.should be_a Bunny::Client
    subject.bunny.status.should be :connected
  end

  describe "publishing messages" do
    let(:message) { 'foo' }

    describe "to a named exchange" do
      let(:exchange_name) { 'my_exchange' }

      it "should load the exchange and publish to it" do
        mock_exchange = stub('exchange')
        subject.bunny.stub(:exchange).with(exchange_name).and_return mock_exchange
        mock_exchange.should_receive(:publish).once.with(message, content_type: 'text/plain', key: 'my_key')
        subject.publish message, content_type: 'text/plain', key: 'my_key', exchange: exchange_name
      end
    end

    describe "without a named exchange" do
      it "should publish to the default exchange" do
        mock_exchange = stub('exchange')
        subject.bunny.stub(:exchange).with('').and_return mock_exchange
        mock_exchange.should_receive(:publish).once.with(message, content_type: 'text/plain', key: 'my_key')
        subject.publish message, content_type: 'text/plain', key: 'my_key'
      end
    end
  end
end
