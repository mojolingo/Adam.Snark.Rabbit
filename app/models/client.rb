class Client
  include Mongoid::Document
  field :name, type: String
  embeds_many :projects
end