class Jid < ContactDetails
  embedded_in :profile

  validates_format_of :address, with: Devise.email_regexp

  after_destroy :inform_destroy

  private

  def generate_confirmation_token
    self.confirmation_token = SecureRandom.uuid
  end
end
