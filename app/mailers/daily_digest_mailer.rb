class DailyDigestMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.daily_digest_mailer.digest.subject
  #
  def digest(user, questions)
    @greeting = "Hi #{user.email}"
    @questions = questions

    mail to: user.email, subject: 'QnA new questions digest'
  end
end
