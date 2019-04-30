class OauthMailer < Devise::Mailer 
  default template_path: 'devise/mailer' # to make sure that your mailer uses the devise views
  default from: 'mail@qna-portal.com'

  def send_confirmation_letter(auth)
    Rails.logger.info 'Confirmation letter sent'
    @url = "#{verify_email_url}?token=#{auth.confirmation_token}"
    mail(to: auth.user.email, subject: 'Confirm email after signing in via social network')
  end
end
