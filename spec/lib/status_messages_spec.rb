require 'spec_helper'

describe StatusMessages do
  before :each do
    @s = StatusMessages.new 'user', 'pass'
  end
  
  it 'requests the correct URL' do
    StatusMessages.expects(:get).once.with('/statuses/public_timeline.json', anything)
    @s.timeline
  end
  
  it 'allows specifying the request type' do
    StatusMessages.expects(:get).once.with('/statuses/friends_timeline.json', anything)
    @s.timeline :friends
  end
  
  it 'allows specifying the start ID' do
    StatusMessages.expects(:get).once.with(anything, has_value({:since_id => 999}))
    @s.timeline :public, 999
  end
  
  it 'should get all status messages by default' do
    args = {
      :basic_auth => {
        :username => 'user',
        :password => 'pass',
      },
      :query => {
        :since_id => 0,
      },
    }
    StatusMessages.expects(:get).once.with(anything, has_entries(args))
    @s.timeline
  end
end