require 'adam_common/message'

require 'faraday'
require 'faraday_middleware'

class MessageProcessor
  def initialize(message)
    @message = message
  end

  def processed_message
    @user ||= fetch_user
    AdamCommon::Message.new source_type: @message.source_type,
                            source_address: @message.source_address,
                            body: @message.body,
                            user: @user
  end

  private

  def fetch_user
    conn = Faraday.new url: "http://#{ENV['ADAM_ROOT_DOMAIN']}" do |c|
      c.basic_auth 'internal', ENV['ADAM_INTERNAL_PASSWORD']
      c.use Faraday::Adapter::NetHttp
      c.use Faraday::Response::Logger
      c.use FaradayMiddleware::ParseJson, content_type: 'application/json'
    end

    response = conn.get '/users/find_for_message.json', message: @message.to_json
    response.body
  end
end
