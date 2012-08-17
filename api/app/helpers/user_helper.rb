module UserHelper
  def user_auth_source_string(user)
    if user.github_username
      "#{user.github_username} on github"
    elsif user.twitter_username
      "#{user.twitter_username} on twitter"
    else
      'auth source unknown'
    end
  end
end
