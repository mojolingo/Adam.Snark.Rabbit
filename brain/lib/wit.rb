require 'typhoeus'
require 'json'

class Wit
  BASE_URL = 'https://api.wit.ai'

  def self.query(message)
    request = Typhoeus::Request.new(
      "#{BASE_URL}/message",
      method: :get,
      params: { q: message },
      headers: { 'Authorization' => "Bearer #{ENV['WIT_API_KEY']}" }
    )

    JSON.decode request.run.body
  end
end
