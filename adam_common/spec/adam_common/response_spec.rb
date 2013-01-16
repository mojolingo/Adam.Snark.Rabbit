require 'spec_helper'

describe AdamCommon::Response do
  let(:target_type)     { :xmpp }
  let(:target_address)  { 'foo@bar.com' }
  let(:body)            { 'Hello there' }

  subject { described_class.new target_type: target_type, target_address: target_address, body: body }

  its(:target_type)     { should == target_type }
  its(:target_address)  { should == target_address }
  its(:body)            { should == body }

  it "should be able to encode to and decode from JSON" do
    subject.should eql(described_class.from_json(subject.to_json))
  end

  describe "equality" do
    context "with no attributes set" do
      it "should be equal" do
        described_class.new.should eql(described_class.new)
      end
    end

    context "with attributes set the same" do
      it "should be equal" do
        described_class.new(target_type: :xmpp).should eql(described_class.new(target_type: :xmpp))
      end
    end

    context "with attributes set differently" do
      it "should be equal" do
        described_class.new(target_type: :email).should_not eql(described_class.new(target_type: :xmpp))
      end
    end
  end
end
