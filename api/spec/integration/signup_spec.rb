require 'spec_helper'

feature "Authentication" do
  context "using github" do
    background { GithubMock.mock }

    scenario "without an existing account" do
      User.where(email: 'ben@langfeld.me').first.should be nil
      visit root_url
      click_link 'Signup'
      click_link 'Github'
      page.should have_content 'Welcome, Ben Langfeld'
      new_user = User.where(email: 'ben@langfeld.me').first
      new_user.name.should be == "Ben Langfeld"
    end
  end
end
