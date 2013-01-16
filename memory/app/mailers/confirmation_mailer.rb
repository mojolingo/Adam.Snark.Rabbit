class ConfirmationMailer < ActionMailer::Base
  default from: "adam@adamrabbit.com"

  def instructions(email_address)
    @confirmation_url = my_profile_confirm_url email_address.confirmation_token
    mail to: email_address.address, subject: 'Adam needs to confirm your email address'
  end
end
