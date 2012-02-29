class Client
  include Mongoid::Document
  field :name, type: String
  field :wisecrack_id, type: String
  embeds_many :projects
end