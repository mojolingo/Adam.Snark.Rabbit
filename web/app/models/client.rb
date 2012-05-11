class Client
  include Mongoid::Document
  field :name, type: String
  embeds_many :projects

  def wisecrack_id
    Wisecrack.get_client_by_name self.name
  end
end