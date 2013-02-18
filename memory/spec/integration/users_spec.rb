require 'spec_helper'

feature 'Users' do
  def message(source_address = 'foo@bar.com/doo', source_type = :xmpp)
    AdamCommon::Message.new source_type: source_type,
                            source_address: source_address
  end

  before do
    AuthGrant.find_or_create_for_oauth GithubMock.data
    Profile.first.jids.create address: 'foo@bar.com'
  end

  context 'when logged in as an unprivileged user' do
    background { logged_in_with :github }

    scenario 'fetching a user by ID' do
      get "/users/#{User.first.id}.json"
      last_response.status.should be 401
    end

    scenario 'getting user data for a message' do
      get '/users/find_for_message.json', message: message.to_json
      last_response.status.should be 401
    end
  end

  context 'when logged in as a normal user' do
    background do
      GithubMock.mock
      logged_in_with :github
    end

    scenario 'getting current user data' do
      page.driver.get '/me.json'
      page.status_code.should be 200
      response = JSON.parse page.source
      response['id'].should == User.first.id.to_s
      response['authentication_token'].should == User.first.authentication_token.to_s
      response.should have_key("profile")
      response.should have_key("auth_grants")
    end
  end

  context 'when logged in as the internal user' do
    background do
      authorize 'internal', (ENV['ADAM_INTERNAL_PASSWORD'] || 'abc123')
    end

    scenario 'getting user data by ID' do
      get "/users/#{User.first.id}.json"
      last_response.status.should be 200
      response = JSON.parse last_response.body
      response.should have_key("profile")
      response.should have_key("auth_grants")
    end

    context "when a user doesn't exist for an ID" do
      scenario 'getting user data by ID' do
        get "/users/1.json"
        last_response.status.should be 404
        last_response.body.should == 'null'
      end
    end

    scenario 'getting user data for a message' do
      get '/users/find_for_message.json', message: message.to_json
      last_response.status.should be 200
      response = JSON.parse last_response.body
      response.should have_key("profile")
      response.should have_key("auth_grants")
    end

    context "when a user doesn't exist for the message's source address" do
      scenario 'getting user data for a message' do
        get '/users/find_for_message.json', message: message('doo@dah.com').to_json
        last_response.status.should be 404
        last_response.body.should == 'null'
      end
    end
  end
end
