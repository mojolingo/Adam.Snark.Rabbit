require 'spec_helper'

describe AuthGrant do
  context "created from Github OAuth" do
    let(:auth_grant) { AuthGrant.find_or_create_for_oauth(GithubMock.data) }

    subject { auth_grant }

    context "user" do
      subject { auth_grant.user }

      its(:social_usernames) { should == { github: 'benlangfeld' } }

      context "profile" do
        subject { auth_grant.user.profile }

        its(:name) { should == 'Ben Langfeld' }
        its(:email_addresses) { subject.map(&:address).should == ['ben@langfeld.me'] }
      end
    end
  end

  context "created from Twitter OAuth" do
    let(:auth_grant) { AuthGrant.find_or_create_for_oauth(TwitterMock.data) }

    subject { auth_grant }

    context "user" do
      subject { auth_grant.user }

      its(:social_usernames) { should == { twitter: 'benlangfeld' } }

      context "profile" do
        subject { auth_grant.user.profile }

        its(:name) { should == 'Ben Langfeld' }
      end
    end
  end
end
