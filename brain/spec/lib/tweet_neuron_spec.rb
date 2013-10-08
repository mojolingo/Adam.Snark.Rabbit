require 'spec_helper'

describe TweetNeuron do
  include NeuronMatchers

  let(:subject) { TweetNeuron.new }

  it "should return an error message if no tweet is provided" do
    interpretation = wit_interpretation 'Tweet this', 'tweet'
    should handle_message('Tweet this', :default_user, interpretation)
      .and_respond_with("You have to tell me what to tweet!")
  end

  it "should send a tweet" do
    interpretation = wit_interpretation 'Tweet Hello from AstriCon', 'tweet', message: 'Hello from AstriCon'
    should handle_message('Tweet this Hello from Astricon', :default_user, interpretation)
      .and_respond_with("Message sent.")
  end

  context "getting a Twitter client" do
    it "should return nil if the user has no credentials for Twitter" do
      subject.get_twitter_client('auth_grants' => []).should be nil
    end

    it "should return an instance of Twitter::Client if credentials are supplied" do
      user = {'auth_grants' => [{provider: :twitter, credentials: {'token' => 'abcd', 'secret' => 'efgh'}}]}
      subject.get_twitter_client(user).should be_a Twitter::Client
    end
  end

end

