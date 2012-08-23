class EmailAddress
  include Mongoid::Document
  include Devise::Models::Confirmable

  field :address, type: String
  field :confirmed_at, type: DateTime
  field :confirmation_token, type: String
  field :confirmation_sent_at, type: DateTime

  attr_accessible :address

  embedded_in :profile

  validates_presence_of :address
  validates_format_of :address, with: Devise.email_regexp

  def self.generate_token(type = nil)
    SecureRandom.uuid
  end

  def self.reconfirmable
    false
  end

  def send_devise_notification(notification)
    # Devise.mailer.send(notification, self).deliver
  end

  def email_changed?
    address_changed?
  end

  def email
    address
  end
end
