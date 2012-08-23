class EmailAddress
  include Mongoid::Document

  field :address, type: String

  embedded_in :profile

  validates_presence_of :address
  validates_format_of :address, with: Devise.email_regexp
end
