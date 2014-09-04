require 'spec_helper'
require_relative 'contact_details_examples'

describe Jid do
  subject { FactoryGirl.create :jid }

  context "with an address that is not of the correct format" do
    subject { FactoryGirl.build :jid, address: 'foobar' }

    it { should be_invalid }
  end

  it_should_behave_like 'contact details'
end
