class GithubIssues < IssueTracker
  BASE_URL = 'https://github.com'

  def formatted_url
    "#{BASE_URL}/#{url}/issues"
  end
end