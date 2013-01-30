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
      subject.email_addresses.map(&:confirmed?).should == [false]
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

  describe "setting futuresimple credentials" do
    it "should save the token on save" do
      subject.futuresimple_username = 'benlangfeld'
      subject.futuresimple_password = 'foobar'

      stub_request(:post, "https://sales.futuresimple.com/api/v1/authentication.json").
         with(body: "email=benlangfeld&password=foobar").
         to_return(status: 200, body: '{"authentication":{"token":"abudw889"}}')

      subject.save

      subject.reload
      subject.futuresimple_token.should == 'abudw889'
    end
  end
end
