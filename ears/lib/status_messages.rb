require 'httparty'

class StatusMessages
  include HTTParty
  include Singleton
  base_uri 'status.mojolingo.com/api'

  def setup(username, password)
    @auth = {:username => username, :password => password}
  end

  def default_options
    {:basic_auth => @auth}
  end

  # Get a timeline of status messages
  # @param [Symbol] Which type of timeline to get. Options may include :public, :friends, :user
  # @param [Fixnum] The ID of the oldest message to consider for the search.  Any message before this ID is ignored.
  # @param [Hash] Hash of options passed to the request
  # @return [Array] Array of Hashes representing messages converted from JSON
  def timeline(which = :public, since_id = 0, options={})
    options = default_options.merge({
      :query => {:since_id   => since_id},
    }).merge(options)
    self.class.get "/statuses/#{which}_timeline.json", options
  end

  # Get the last status for the provided user.
  # @param [String] Username for which to retrieve status messages
  # @param [Fixnum] Count of messages to return, defaults to 1
  # @return [Array] Array of Hashes representing messages converted from JSON
  def last_status_for(username, count = 1)
    # the second parameter is unused, hence nil
    timeline :user, nil, :query => { :screen_name => username, :count => count }
  end

  class << self
    def method_missing(method, *args, &block)
      instance.send method, *args, &block
    end
  end
end