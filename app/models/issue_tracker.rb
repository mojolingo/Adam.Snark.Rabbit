class IssueTracker
  include Mongoid::Document
  embedded_in :project
  
  field :name, type: String
  field :url, type: String
  
  def formatted_url
    url
  end
end