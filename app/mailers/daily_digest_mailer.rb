class DailyDigestMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.daily_digest_mailer.digest.subject
  #
  def digest(user)
    @greeting = "Hi #{user.email}"

    # Cant pass it via Service - 
    #get ActiveJob::SerializationError: Unsupported argument type: ActiveRecord::Relation
    @questions = Question.today
    mail to: user.email, subject: 'QnA new questions digest'
  end
end
