require 'spec_helper'

feature "Authentication" do
  context "using github" do
    background { GithubMock.mock }

    context "without an existing account" do
      background { User.first.should be nil }

      scenario "it should create an account and log the user in" do
        visit root_url
        click_link 'Login with Github'
        page.should have_content 'Welcome, Ben Langfeld'
        new_user = User.first
        expect(new_user.name).to eq("Ben Langfeld")
        expect(new_user.github_username).to eq(GithubMock.data.info.nickname)
      end
    end

    context "with an existing account" do
      background do
        new_user = User.find_or_create_for_github_oauth GithubMock.data
        User.first.should be == new_user
        new_user.sign_in_count.should be == 0
      end

      scenario "it should use the original account and log the user in" do
        visit root_url
        click_link 'Login with Github'
        page.should have_content 'Welcome, Ben Langfeld'
        new_user = User.first
        new_user.name.should be == "Ben Langfeld"
        new_user.sign_in_count.should be == 1
      end
    end
  end

  context "using twitter" do
    background { TwitterMock.mock }

    context "without an existing account" do
      background { User.first.should be nil }

      scenario "it should create an account and log the user in" do
        visit root_url
        click_link 'Login with Twitter'
        page.should have_content 'Welcome, Ben Langfeld'
        new_user = User.first
        expect(new_user.name).to eq("Ben Langfeld")
        expect(new_user.twitter_username).to eq(TwitterMock.data.info.nickname)
      end
    end

    context "with an existing account" do
      background do
        new_user = User.find_or_create_for_twitter_oauth TwitterMock.data
        User.first.should be == new_user
        new_user.sign_in_count.should be == 0
      end

      scenario "it should use the original account and log the user in" do
        visit root_url
        click_link 'Login with Twitter'
        page.should have_content 'Welcome, Ben Langfeld'
        new_user = User.first
        new_user.name.should be == "Ben Langfeld"
        new_user.sign_in_count.should be == 1
      end
    end
  end
end
