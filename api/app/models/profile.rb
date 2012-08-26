class Profile
  include Mongoid::Document

  field :name, type: String

  attr_accessible :name, :email_addresses_attributes

  belongs_to :user

  embeds_many :email_addresses, cascade_callbacks: true
  accepts_nested_attributes_for :email_addresses, allow_destroy: true

  validates_presence_of :name

  # Find an email address by its confirmation token and try to confirm it.
  # If no record is found, returns a new record with an error.
  # If the record is already confirmed, create an error for the record
  def confirm_by_token(confirmation_token)
    confirmable = email_addresses.select { |a| a.confirmation_token == confirmation_token }.first
    if confirmable
      confirmable.confirm!
    else
      confirmable = email_addresses.build
      if confirmation_token.present?
        confirmable.errors.add(:confirmation_token, :invalid)
      else
        confirmable.errors.add(:confirmation_token, :blank)
      end
    end
    confirmable
  end
end
