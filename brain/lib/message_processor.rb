require 'adam_signals/message'

require 'faraday'
require 'faraday_middleware'

require 'uri'

class MessageProcessor
  def initialize(message)
    @message = message
    @memory_url = URI.parse ENV['ADAM_MEMORY_URL']
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
    conn = Faraday.new url: @memory_url.to_s do |c|
      c.basic_auth ENV['ADAM_MEMORY_INTERNAL_USERNAME'], ENV['ADAM_MEMORY_INTERNAL_PASSWORD']
      c.adapter :net_http
      c.response :logger
      c.use FaradayMiddleware::ParseJson, content_type: 'application/json'
      c.response :raise_error
    end

    response = conn.get "#{@memory_url.path}/users/find_for_message.json", message: @message.to_json
    response.body
  rescue Faraday::Error::ResourceNotFound
    nil
  end
end
