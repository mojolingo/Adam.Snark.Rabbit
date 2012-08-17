require 'spec_helper'

feature "Authentication" do
  context "using github" do
    background { GithubMock.mock }

    context "without an existing account" do
      background { User.where(email: 'ben@langfeld.me').first.should be nil }

      scenario "it should create an account and log the user in" do
        visit root_url
        click_link 'Login with Github'
        page.should have_content 'Welcome, Ben Langfeld'
        new_user = User.where(email: 'ben@langfeld.me').first
        expect(new_user.name).to eq("Ben Langfeld")
        expect(new_user.github_username).to eq(GithubMock.data.info.nickname)
      end
    end

    context "with an existing account" do
      background do
        new_user = User.find_or_create_for_github_oauth GithubMock.data
        User.where(email: 'ben@langfeld.me').first.should be == new_user
        new_user.sign_in_count.should be == 0
      end

      scenario "it should use the original account and log the user in" do
        visit root_url
        click_link 'Login with Github'
        page.should have_content 'Welcome, Ben Langfeld'
        new_user = User.where(email: 'ben@langfeld.me').first
        new_user.name.should be == "Ben Langfeld"
        new_user.sign_in_count.should be == 1
      end
    end
  end
end
