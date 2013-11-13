require 'spec_helper'

describe User do
  context "created from Github OAuth" do
    it "should allow finding by github uid" do
      AuthGrant.find_or_create_for_oauth GithubMock.data
      user = User.find_by_github_user_id(210221)
      expect(user.name).to eq('Ben Langfeld')
      expect(user.authentication_token.length).to be > 5
    end
  end

  context "created from Twitter OAuth" do
    it "should allow finding by twitter uid" do
      AuthGrant.find_or_create_for_oauth TwitterMock.data
      user = User.find_by_twitter_user_id('4508241')
      expect(user.name).to eq('Ben Langfeld')
      expect(user.authentication_token.length).to be > 5
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
        AdamSignals::Message.new source_type: :phone, source_address: 'tel:12345', auth_address: jid
      end

      it "should find the correct user" do
        User.find_for_message(message).should == User.first
      end

      context "of the built in format" do
        let(:jid) { "#{User.first.id}@#{ENV['ADAM_ROOT_DOMAIN']}"}

        it "should find the user" do
          User.find_for_message(message).should == User.first
        end

        context "with the wrong domain" do
          let(:jid) { "#{User.first.id}@ddj29389j2d39.com"}

          it "should not find the user" do
            User.find_for_message(message).should be_nil
          end
        end

        context "with a user that doesn't exist" do
          let(:jid) { "rj93j2jko2ko9k39@#{ENV['ADAM_ROOT_DOMAIN']}"}

          it "should not find the user" do
            User.find_for_message(message).should be_nil
          end
        end
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
