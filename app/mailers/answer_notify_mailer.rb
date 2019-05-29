class AnswerNotifyMailer < ApplicationMailer
  def notify(user, answer)
    @greeting = "Hi #{user.email}"
    @answer = answer
    mail to: user.email, subject: "QnA: new answer to the question"
  end
end
