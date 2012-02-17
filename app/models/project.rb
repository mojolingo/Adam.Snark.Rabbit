class Project
  include Mongoid::Document
  field :name,        type: String
  embedded_in :client
  embeds_many :source_repositories
  embeds_many :issue_trackers
end