class PivotalTracker < IssueTracker
  BASE_URL = 'https://pivotaltracker.com/projects'

  def formatted_url
    "#{BASE_URL}/#{url}"
  end
end