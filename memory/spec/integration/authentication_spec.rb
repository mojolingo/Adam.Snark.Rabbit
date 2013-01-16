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
        page.should have_content 'Logged in as Ben Langfeld (benlangfeld on github)'
        new_user = User.first
        expect(new_user.social_usernames).to eq(github: GithubMock.data.info.nickname)
      end
    end

    context "with an existing account" do
      background do
        logged_in_with :github
        click_link 'Logout'
        User.first.sign_in_count.should be == 1
      end

      scenario "it should use the original account and log the user in" do
        visit root_url
        click_link 'Login with Github'
        page.should have_content 'Welcome, Ben Langfeld'
        page.should have_content 'Logged in as Ben Langfeld (benlangfeld on github)'
        User.count.should be 1
        User.first.sign_in_count.should be == 2
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
        page.should have_content 'Logged in as Ben Langfeld (benlangfeld on twitter)'
        new_user = User.first
        expect(new_user.social_usernames).to eq(twitter: TwitterMock.data.info.nickname)
      end
    end

    context "with an existing account" do
      background do
        logged_in_with :twitter
        click_link 'Logout'
        User.first.sign_in_count.should be == 1
      end

      scenario "it should use the original account and log the user in" do
        visit root_url
        click_link 'Login with Twitter'
        page.should have_content 'Welcome, Ben Langfeld'
        page.should have_content 'Logged in as Ben Langfeld (benlangfeld on twitter)'
        User.count.should be 1
        User.first.sign_in_count.should be == 2
      end
    end
  end
end
