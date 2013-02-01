require 'spec_helper'

describe User do
  context "created from Github OAuth" do
    it "should allow finding by github uid" do
      AuthGrant.find_or_create_for_oauth GithubMock.data
      expect(User.find_by_github_user_id(210221).name).to eq('Ben Langfeld')
    end
  end

  context "created from Twitter OAuth" do
    it "should allow finding by twitter uid" do
      AuthGrant.find_or_create_for_oauth TwitterMock.data
      expect(User.find_by_twitter_user_id('4508241').name).to eq('Ben Langfeld')
    end
  end

  describe "finding for a message" do
    before do
      AuthGrant.find_or_create_for_oauth GithubMock.data
      Profile.first.jids.create address: 'foo@bar.com'
    end

    context "with a JID" do
      let(:jid) { 'foo@bar.com/doo' }
      let(:message) do
        AdamCommon::Message.new source_type: :xmpp, source_address: jid
      end

      it "should find the correct user" do
        User.find_for_message(message).should == User.first
      end

      context "for which there is no record" do
        let(:jid) { 'doo@dah.com' }

        it "should return nil" do
          User.find_for_message(message).should be_nil
        end
      end
    end
  end
end
