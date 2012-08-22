module UserHelper
  def user_auth_source_string(user)
    usernames = user.social_usernames
    return 'auth source unknown' if usernames.empty?
    usernames.inject([]) do |a, (provider, username)|
      a << "#{username} on #{provider}"
    end.join ','
  end
end
