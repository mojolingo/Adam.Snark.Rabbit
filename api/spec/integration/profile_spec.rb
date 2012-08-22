require 'spec_helper'

feature 'Profile' do
  context 'without being logged in' do
    scenario 'viewing my profile' do
      visit my_profile_url
      page.should have_content 'need to sign in'
    end
  end

  context 'when logged in' do
    background { logged_in_with_github }

    scenario 'viewing my profile' do
      click_link 'My Profile'
      page.should have_content 'Ben Langfeld'
    end

    scenario 'editing my profile' do
      click_link 'My Profile'
      click_link '(edit)'
      fill_in 'Name', with: 'Joe Bloggs'
      click_button 'Update Profile'
      page.should have_content 'Joe Bloggs'
    end
  end
end
