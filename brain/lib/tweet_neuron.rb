require 'twitter'

class TweetNeuron
  def initialize
  end

  def intent
    'tweet'
  end

  def reply(message, interpretation)
    client = get_twitter_client(message.user)
    return "You must log in via Twitter so I can help you tweet." unless client
    entities = interpretation['outcome']['entities']
    return "You have to tell me what to tweet!" unless entities.has_key? 'message'

    client.update entities['message']['value']
    "Message sent."
  end

  def get_twitter_client(user)
    grant = user['auth_grants'].select { |grant| grant[:provider] == :twitter }.first
    if grant
      Twitter::Client.new do |config|
        config.consumer_key        = ENV['TWITTER_KEY']
        config.consumer_secret     = ENV['TWITTER_SECRET']
        config.access_token        = grant[:credentials]['token']
        config.access_token_secret = grant[:credentials]['secret']
      end
    end
  end
end
