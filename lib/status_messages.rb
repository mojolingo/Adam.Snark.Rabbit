require 'httparty'

class StatusMessages
  include HTTParty
  base_uri 'status.mojolingo.com/api'
  
  def initialize(username, password)
    @auth = {:username => username, :password => password}
  end
  
  def timeline(which = :public, since_id = 0, options={})
    options = {
      :basic_auth => @auth,
      :query => {:since_id   => since_id},
    }.merge(options)
    self.class.get "/statuses/#{which}_timeline.json", options
  end
end