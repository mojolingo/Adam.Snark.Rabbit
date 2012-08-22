require 'spec_helper'

describe User do
  context "created from Github OAuth" do
    subject { AuthGrant.find_or_create_for_oauth(GithubMock.data).user }

    its(:name)              { should == 'Ben Langfeld' }
    its(:email)             { should == 'ben@langfeld.me' }
    its(:social_usernames)  { should == { github: 'benlangfeld' } }

    it "should allow finding by github uid" do
      AuthGrant.find_or_create_for_oauth GithubMock.data
      expect(User.find_by_github_user_id(210221).name).to eq('Ben Langfeld')
    end
  end

  context "created from Twitter OAuth" do
    subject { AuthGrant.find_or_create_for_oauth(TwitterMock.data).user }

    its(:name)              { should == 'Ben Langfeld' }
    its(:social_usernames)  { should == { twitter: 'benlangfeld' } }

    it "should allow finding by twitter uid" do
      AuthGrant.find_or_create_for_oauth TwitterMock.data
      expect(User.find_by_twitter_user_id('4508241').name).to eq('Ben Langfeld')
    end
  end
end
