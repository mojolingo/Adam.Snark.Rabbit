class Profile
  include Mongoid::Document

  field :name, type: String

  belongs_to :user

  embeds_many :email_addresses
  accepts_nested_attributes_for :email_addresses, allow_destroy: true

  validates_presence_of :name
end
