require 'spec_helper'
require_relative 'confirmable_examples'

shared_examples_for "contact details" do
  it { should be_valid }

  context "without an address" do
    subject { FactoryGirl.build described_class.name.underscore, address: '' }

    it { should be_invalid }
  end

  it_should_behave_like "confirmable"
end
