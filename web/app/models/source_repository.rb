class SourceRepository
  include Mongoid::Document
  embedded_in :project
  
  field :url, type: String
end