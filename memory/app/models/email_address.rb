class EmailAddress < ContactDetails
  embedded_in :profile

  validates_format_of :address, with: Devise.email_regexp

  private

  def generate_confirmation_token
    self.confirmation_token = SecureRandom.uuid
  end

  def send_confirmation_instructions
    ConfirmationMailer.instructions(self).deliver
  end
end
