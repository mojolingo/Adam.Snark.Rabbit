require 'spec_helper'

describe EmailAddress do
  subject { FactoryGirl.build :email_address }

  it { should be_valid }

  context "without an address" do
    subject { FactoryGirl.build :email_address, address: '' }

    it { should be_invalid }
  end

  context "with an address that is not of the correct format" do
    subject { FactoryGirl.build :email_address, address: 'foobar' }

    it { should be_invalid }
  end

  it { should_not be_confirmed }
end
