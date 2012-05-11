class GithubRepository < SourceRepository
  BASE_URL = 'https://github.com'

  def formatted_url
    "#{BASE_URL}/#{url}"
  end
end