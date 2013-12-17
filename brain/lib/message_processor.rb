require 'adam_signals/message'

require 'faraday'
require 'faraday_middleware'

class MessageProcessor
  def initialize(message)
    @message = message
  end

  def processed_message
    @user ||= fetch_user
    AdamSignals::Message.new source_type: @message.source_type,
                            source_address: @message.source_address,
                            auth_address: @message.auth_address,
                            body: @message.body,
                            user: @user
  end

  private

  def fetch_user
    conn = Faraday.new url: ENV['ADAM_MEMORY_URL'] do |c|
      c.basic_auth ENV['ADAM_MEMORY_INTERNAL_USERNAME'], ENV['ADAM_MEMORY_INTERNAL_PASSWORD']
      c.adapter :net_http
      c.response :logger
      c.use FaradayMiddleware::ParseJson, content_type: 'application/json'
      c.response :raise_error
    end

    response = conn.get 'users/find_for_message.json', message: @message.to_json
    response.body
  rescue Faraday::Error::ResourceNotFound
    nil
  end
end
