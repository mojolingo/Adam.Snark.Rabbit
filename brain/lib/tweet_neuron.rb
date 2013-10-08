class TweetNeuron
  def initialize
  end

  def intent
    'tweet'
  end

  def reply(message, interpretation)
    return message.inspect
    client = get_twitter_client(message.user)
    return "You must log in via Twitter so I can help you tweet." unless client
    entities = interpretation['outcome']['entities']
    return "You have to tell me what to tweet!" unless entities.has_key? 'message'

    client.update entities['message']['value']
    "Message sent."
  end

  def get_twitter_client(user)
    if user['auth_grants'].select { |grant| grant[:provider] == :twitter }
      Twitter::REST::Client.new do |config|
        config.consumer_key        = ENV['TWITTER_KEY']
        config.consumer_secret     = ENV['TWITTER_SECRET']
        config.access_token        = grant[:credentials]['token']
        config.access_token_secret = grant[:credentials]['secret']
      end
    end
  end
end
