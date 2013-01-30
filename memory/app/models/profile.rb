class Profile
  include Mongoid::Document

  field :name, type: String
  field :futuresimple_username, type: String
  field :futuresimple_token, type: String
  attr_accessor :futuresimple_password

  attr_accessible :name, :email_addresses_attributes, :jids_attributes, :futuresimple_username, :futuresimple_password

  belongs_to :user

  embeds_many :email_addresses, cascade_callbacks: true
  accepts_nested_attributes_for :email_addresses, allow_destroy: true

  embeds_many :jids, cascade_callbacks: true
  accepts_nested_attributes_for :jids, allow_destroy: true

  validates_presence_of :name

  before_save :fetch_futuresimple_token

  # Find an email address by its confirmation token and try to confirm it.
  # If no record is found, returns a new record with an error.
  # If the record is already confirmed, create an error for the record
  def confirm_by_token(confirmation_token, type = :email_address)
    type = type.to_s.pluralize
    if confirmable = send(type).select { |a| a.confirmation_token == confirmation_token }.first
      confirmable.confirm!
    else
      confirmable = send(type).build
      if confirmation_token.present?
        confirmable.errors.add(:confirmation_token, :invalid)
      else
        confirmable.errors.add(:confirmation_token, :blank)
      end
    end
    confirmable
  end

  private

  def fetch_futuresimple_token
    return unless futuresimple_username.present? && futuresimple_password.present?
    session = Pipejump::Session.new email: futuresimple_username, password: futuresimple_password
    self.futuresimple_token = session.token
  end
end
