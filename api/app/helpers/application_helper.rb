module ApplicationHelper
  TWITTER_LOOKUP = Hash.new { |h, k| h[k] = k.to_s }.merge alert: 'warning', notice: 'info'

  def twitterized_type(type)
    TWITTER_LOOKUP[type]
  end
end
