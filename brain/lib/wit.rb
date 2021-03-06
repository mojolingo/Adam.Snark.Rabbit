require 'faraday'
require 'faraday_middleware'

class Wit
  BASE_URL = 'https://api.wit.ai'

  def self.query(message)
    conn = Faraday.new url: BASE_URL do |c|
      c.adapter :net_http
      c.response :logger
      c.use FaradayMiddleware::ParseJson, content_type: 'application/json'
      c.response :raise_error
    end

    conn.get '/message' do |req|
      req.params['q'] = message
      req.headers['Authorization'] = "Bearer #{ENV['WIT_API_KEY']}"
      req.headers['Accept'] = 'application/vnd.wit.20140201'
    end.body
  end
end
