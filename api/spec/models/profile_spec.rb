require 'spec_helper'

describe Profile do
  subject { FactoryGirl.build :profile }

  it { should be_valid }

  context "without a name" do
    subject { FactoryGirl.build :profile, name: '' }

    it { should be_invalid }
  end

  describe "#email_addresses" do
    it "starts off empty" do
      subject.email_addresses.should == []
    end

    it "can have addresses added" do
      subject.email_addresses.build address: 'foo@bar.com'
      subject.email_addresses.map(&:address).should == ['foo@bar.com']
    end

    context "when it has an email address on creation" do
      subject { FactoryGirl.build :profile, email_addresses_attributes: [{address: 'foo@bar.com'}] }

      it "has an email address" do
        subject.email_addresses.map(&:address).should == ['foo@bar.com']
      end

      it "can remove email addresses" do
        subject.update_attributes email_addresses_attributes: [
          {id: subject.email_addresses.first.id, _destroy: '1'}
        ]
        subject.reload
        subject.should have(0).email_addresses
      end

      it "can modify email addresses via nested attributes" do
        subject.update_attributes email_addresses_attributes: [
          {id: subject.email_addresses.first.id, address: 'doo@dah.com'}
        ]
        subject.reload
        subject.email_addresses.map(&:address).should == ['doo@dah.com']
      end
    end
  end
end
