require 'spec_helper'
require_relative 'contact_details_examples'

describe Jid do
  subject { FactoryGirl.create :jid }

  context "with an address that is not of the correct format" do
    subject { FactoryGirl.build :jid, address: 'foobar' }

    it { should be_invalid }
  end

  it_should_behave_like 'contact details'

  it 'should publish a jid.created event on creation' do
    payload = {jid: 'doo@dah.com'}.to_json
    AMQPConnection.instance.should_receive(:publish).once.with(payload, content_type: 'application/json', key: 'jid.created')
    FactoryGirl.create :jid, address: 'doo@dah.com'
  end

  it 'should not publish a jid.updated event when trying to save an invalid record' do
    AMQPConnection.instance.should_receive(:publish).never
    expect { FactoryGirl.create :jid, address: '' }.to raise_error(Mongoid::Errors::Validations)
  end

  it 'should publish a jid.changed event after changing JID' do
    old_jid = subject.address
    subject.confirm!.should be_true
    payload = {old_jid: old_jid, new_jid: 'new_test@example.com'}.to_json
    AMQPConnection.instance.should_receive(:publish).once.with(payload, content_type: 'application/json', key: 'jid.updated')
    subject.update_attributes(address: 'new_test@example.com')
  end

  it 'should publish a jid.removed event on creation' do
    jid = FactoryGirl.create :jid, address: 'doo@dah.com'
    payload = {jid: 'doo@dah.com'}.to_json
    AMQPConnection.instance.should_receive(:publish).once.with(payload, content_type: 'application/json', key: 'jid.removed')
    jid.destroy
  end
end
