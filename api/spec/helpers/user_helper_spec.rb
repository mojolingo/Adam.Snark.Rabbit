require 'spec_helper'

describe UserHelper do
  describe "#user_auth_source_string" do
    context "with a user with no auth source" do
      let(:user) { User.new }

      it "should return 'auth source unknown'" do
        expect(helper.user_auth_source_string(user)).to eq('auth source unknown')
      end
    end

    context "with a github authed user" do
      let(:user) { User.find_or_create_for_oauth(GithubMock.data) }

      it "should return the github username" do
        expect(helper.user_auth_source_string(user)).to eq('benlangfeld on github')
      end
    end

    context "with a twitter authed user" do
      let(:user) { User.find_or_create_for_oauth(TwitterMock.data) }

      it "should return the twitter username" do
        expect(helper.user_auth_source_string(user)).to eq('benlangfeld on twitter')
      end
    end
  end
end
