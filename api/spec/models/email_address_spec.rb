require 'spec_helper'

describe EmailAddress do
  subject { FactoryGirl.build :email_address }

  it { should be_valid }

  context "without an address" do
    subject { FactoryGirl.build :email_address, address: '' }

    it { should be_invalid }
  end
end
