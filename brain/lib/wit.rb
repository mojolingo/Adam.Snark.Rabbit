require 'faraday'
require 'faraday_middleware'
require 'cgi'

class Wit
  BASE_URL = 'https://api.wit.ai'

  def self.query(message)
    conn = Faraday.new url: BASE_URL do |c|
      c.basic_auth 'internal', ENV['ADAM_INTERNAL_PASSWORD']
      c.adapter :net_http
      c.response :logger
      c.use FaradayMiddleware::ParseJson, content_type: 'application/json'
      c.response :raise_error
    end

    response = conn.get '/message' do |req|
      req.params['q'] = message
      req.headers['Authorization'] = "Bearer #{ENV['WIT_API_KEY']}"
    end
    remove_encoding response.body
  end

  def self.remove_encoding(message)
    message['msg_body'] = CGI.unescapeHTML message['msg_body']
    message['outcome']['entities'].keys.each do |entity|
      message['outcome']['entities'][entity]['body'] = CGI.unescapeHTML message['outcome']['entities'][entity]['body'] 
      message['outcome']['entities'][entity]['value'] = CGI.unescapeHTML message['outcome']['entities'][entity]['value'] 
    end
    message
  end
end
