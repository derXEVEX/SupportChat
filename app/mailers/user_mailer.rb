class UserMailer < ApplicationMailer
  default from: 'no-reply@supportchat.com'

  def email_confirmation(user)
    @user = user
    @url  = confirmation_url(token: user.confirmation_token)
    mail(to: @user.unconfirmed_email, subject: 'Bitte bestätige deine neue E-Mail-Adresse')
  end
end
