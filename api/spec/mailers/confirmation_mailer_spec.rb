require "spec_helper"

describe ConfirmationMailer do
  describe "#instructions" do
    let(:email_address) { FactoryGirl.create :email_address }
    subject { ConfirmationMailer.instructions email_address }

    its(:subject) { should == 'Adam needs to confirm your email address' }

    its(:to) { should == [email_address.address] }

    its(:from) { should == ['adam@adamrabbit.com'] }

    it 'includes a confirmation link' do
      subject.body.encoded.should match(my_profile_confirm_url(email_address.confirmation_token))
    end
  end
end
