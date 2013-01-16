require 'spec_helper'

describe AdamCommon::Message do
  let(:source_type)     { :xmpp }
  let(:source_address)  { 'foo@bar.com' }
  let(:body)            { 'Hello there' }

  subject { described_class.new source_type: source_type, source_address: source_address, body: body }

  its(:source_type)     { should == source_type }
  its(:source_address)  { should == source_address }
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
        described_class.new(source_type: :xmpp).should eql(described_class.new(source_type: :xmpp))
      end
    end

    context "with attributes set differently" do
      it "should be equal" do
        described_class.new(source_type: :email).should_not eql(described_class.new(source_type: :xmpp))
      end
    end
  end
end
