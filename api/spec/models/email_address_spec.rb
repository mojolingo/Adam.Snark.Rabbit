require 'spec_helper'

describe EmailAddress do
  subject { FactoryGirl.create :email_address }

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

  its(:confirmation_token) do
    should be_a String
    should_not be_empty
  end

  it 'should never generate the same confirmation token for different records' do
    confirmation_tokens = []
    3.times do
      token = FactoryGirl.create(:email_address).confirmation_token
      confirmation_tokens.should_not include(token)
      confirmation_tokens << token
    end
  end

  it 'should confirm a record by updating confirmed at' do
    subject.confirmed_at.should be_nil
    subject.confirm!.should be_true
    subject.confirmed_at.to_f.should be_within(0.5).of(Time.now.to_f)
  end

  it 'should clear confirmation token while confirming a record' do
    subject.confirmation_token.should be_present
    subject.confirm!
    subject.confirmation_token.should be_nil
  end

  it 'should verify whether a record is confirmed or not' do
    subject.should_not be_confirmed
    subject.confirm!
    subject.should be_confirmed
  end

  it 'should not confirm a record already confirmed' do
    subject.confirm!.should be_true
    subject.errors[:address].should be_empty

    subject.confirm!.should be_false
    subject.errors[:address].join.should == "was already confirmed, please try signing in"
  end

  it 'should find and confirm a record automatically' do
    confirmed_email = subject.profile.confirm_by_token(subject.confirmation_token)
    confirmed_email.should == subject
    subject.reload.should be_confirmed
  end

  it 'should return a new record with errors when a invalid token is given' do
    confirmed_record = subject.profile.confirm_by_token('invalid_confirmation_token')
    confirmed_record.should_not be_persisted
    confirmed_record.errors[:confirmation_token].join.should == "is invalid"
  end

  it 'should return a new record with errors when a blank token is given' do
    confirmed_record = subject.profile.confirm_by_token('')
    confirmed_record.should_not be_persisted
    confirmed_record.errors[:confirmation_token].join.should == "can't be blank"
  end

  it 'should generate errors for a user email if user is already confirmed' do
    subject.confirm!
    confirmed_record = subject.profile.confirm_by_token(subject.confirmation_token)
    confirmed_record.should be_confirmed
    confirmed_record.errors[:address].join.should == "was already confirmed, please try signing in"
  end

  it 'should send a confirmation email on creation' do
    assert_email_sent to: ['doo@dah.com'], subject: 'Adam needs to confirm your email address' do
      FactoryGirl.create :email_address, address: 'doo@dah.com'
    end
  end

  it 'should not send confirmation when trying to save an invalid record' do
    assert_email_not_sent do
      expect { FactoryGirl.create :email_address, address: '' }.to raise_error
    end
  end

  it 'should generate confirmation token after changing address' do
    subject.confirm!.should be_true
    subject.confirmation_token.should be_nil
    subject.update_attributes(address: 'new_test@example.com').should be_true
    subject.reload
    subject.confirmation_token.should be_a String
    subject.confirmation_token.should_not be_empty
  end

  it 'should regenerate confirmation token after changing address' do
    token = subject.confirmation_token
    subject.update_attributes(address: 'new_test@example.com').should be_true
    subject.reload
    subject.confirmation_token.should be_a String
    subject.confirmation_token.should_not be_empty
    subject.confirmation_token.should_not == token
  end

  it 'should send confirmation instructions by email after changing email' do
    subject.confirm!.should be_true
    assert_email_sent to: ['new_test@example.com'], subject: 'Adam needs to confirm your email address' do
      subject.update_attributes(address: 'new_test@example.com')
    end
  end

  it 'should not stay confirmed when email is changed' do
    subject.confirm!.should be_true
    subject.update_attributes(address: 'new_test@example.com').should be_true
    subject.should_not be_confirmed
  end
end
