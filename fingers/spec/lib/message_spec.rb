require 'spec_helper'

require_relative '../../lib/message'

describe Message do
  let(:source_type)     { :xmpp }
  let(:source_address)  { 'foo@bar.com' }
  let(:body)            { 'Hello there' }

  subject { described_class.new source_type: source_type, source_address: source_address, body: body }

  its(:source_type)     { should == source_type }
  its(:source_address)  { should == source_address }
  its(:body)            { should == body }

  its(:respond_to)      { should == source_address }
end
