require 'httparty'

class StatusMessages
  include HTTParty
  base_uri 'status.mojolingo.com/api'

  def initialize(username, password)
    @auth = {:username => username, :password => password}
  end

  def default_options
    {:basic_auth => @auth}
  end

  def timeline(which = :public, since_id = 0, options={})
    options = default_options.merge({
      :query => {:since_id   => since_id},
    }).merge(options)
    self.class.get "/statuses/#{which}_timeline.json", options
  end

  def last_status_for(username, count = 1)
    # the second parameter is unused, hence nil
    timeline :user, nil, :query => { :screen_name => username, :count => count }
  end
end