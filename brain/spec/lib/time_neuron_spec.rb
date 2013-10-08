require 'spec_helper'
require 'timecop'

describe TimeNeuron do
  let(:subject) { TimeNeuron.new }

  it "should read the current time" do 
    Timecop.freeze Time.local(2013, 10, 9, 8, 7, 6)
    subject.reply(nil, nil).should =~ /The time is\s+8:07 AM/
  end
end

