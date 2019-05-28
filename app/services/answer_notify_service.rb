class AnswerNotifyService
  def send_notification(answer)
   # @answers = Answer.today(question)
    answer.question.subscriptions.find_each(batch_size: 500) do |subscription|
      AnswerNotifyMailer.notify(subscription.author, answer).deliver_later
    end
  end
end
