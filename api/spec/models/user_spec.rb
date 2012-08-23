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
end
