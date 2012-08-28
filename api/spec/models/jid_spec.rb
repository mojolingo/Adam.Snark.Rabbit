require 'spec_helper'
require_relative 'contact_details_examples'

describe Jid do
  subject { FactoryGirl.create :jid }

  context "with an address that is not of the correct format" do
    subject { FactoryGirl.build :jid, address: 'foobar' }

    it { should be_invalid }
  end

  it_should_behave_like 'contact details'

  # it 'should send a confirmation email on creation' do
  #   assert_email_sent to: ['doo@dah.com'], subject: 'Adam needs to confirm your email address' do
  #     FactoryGirl.create :email_address, address: 'doo@dah.com'
  #   end
  # end

  # it 'should not send confirmation when trying to save an invalid record' do
  #   assert_email_not_sent do
  #     expect { FactoryGirl.create :email_address, address: '' }.to raise_error
  #   end
  # end

  # it 'should send confirmation instructions by email after changing email' do
  #   subject.confirm!.should be_true
  #   assert_email_sent to: ['new_test@example.com'], subject: 'Adam needs to confirm your email address' do
  #     subject.update_attributes(address: 'new_test@example.com')
  #   end
  # end
end
