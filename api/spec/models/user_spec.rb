require 'spec_helper'

describe User do
  context "created from Github OAuth" do
    subject { User.find_or_create_for_github_oauth(GithubMock.data).reload }

    its(:name)            { should == 'Ben Langfeld' }
    its(:email)           { should == 'ben@langfeld.me' }
    its(:github_username) { should == 'benlangfeld' }

    it "should allow finding by github uid" do
      User.find_or_create_for_github_oauth GithubMock.data
      expect(User.find_by_github_user_id(210221).name).to eq('Ben Langfeld')
    end
  end
end
