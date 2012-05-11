require 'spec_helper'

describe Wisecrack do
  describe '#record_time' do
    it 'should raise ArgumentError if not passed the required inputs' do
      expect { Wisecrack.record_time }.to raise_error ArgumentError
    end
  end
end