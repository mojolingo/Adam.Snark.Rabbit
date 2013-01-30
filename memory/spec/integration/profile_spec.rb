require 'spec_helper'

feature 'Profile' do
  context 'without being logged in' do
    scenario 'viewing my profile' do
      visit my_profile_url
      page.should have_content 'need to sign in'
    end
  end

  context 'when logged in' do
    background { logged_in_with :github }

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

    scenario 'adding an email address' do
      click_link 'My Profile'
      page.should have_content 'ben@langfeld.me'
      page.should_not have_content 'foo@bar.com'
      click_link '(edit)'
      click_link 'remove address'
      click_link 'Add Email Address'
      fill_in 'Address', with: 'foo@bar.com'
      click_button 'Update Profile'
      page.should have_content 'foo@bar.com'
      page.should_not have_content 'ben@langfeld.me'

      new_address = Profile.first.email_addresses.first
      new_address.address.should == 'foo@bar.com'
      new_address.should_not be_confirmed

      open_email 'foo@bar.com'
      current_email.click_link 'confirm'

      new_address.reload
      new_address.should be_confirmed
    end

    scenario 'adding a JID' do
      profile = Profile.first
      profile.jids.create address: 'foo@jabber.org'

      click_link 'My Profile'
      page.should have_content 'ben@langfeld.me'
      page.should have_content 'foo@jabber.org'
      click_link '(edit)'
      click_link 'remove JID'
      click_link 'Add JID'
      fill_in 'JID', with: 'doo@jabber.org'
      click_button 'Update Profile'
      page.should_not have_content 'foo@jabber.org'
      page.should have_content 'doo@jabber.org'
      page.should have_content 'ben@langfeld.me'

      new_address = Profile.first.jids.first
      new_address.address.should == 'doo@jabber.org'
      new_address.should_not be_confirmed
    end

    scenario 'authenticating with futuresimple' do
      stub_request(:post, "https://sales.futuresimple.com/api/v1/authentication.json").
         with(body: "email=benlangfeld&password=foobar").
         to_return(status: 200, body: '{"authentication":{"token":"abudw889"}}')

      click_link 'My Profile'
      click_link '(edit)'
      fill_in 'Futuresimple Username', with: 'benlangfeld'
      fill_in 'Futuresimple Password', with: 'foobar'
      click_button 'Update Profile'

      page.should have_content 'Futuresimple Username: benlangfeld'
      Profile.first.futuresimple_token.should == 'abudw889'
    end
  end
end
