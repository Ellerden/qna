class AnswerNotifyJob < ApplicationJob
  queue_as :mailers

  def perform(answer)
    AnswerNotifyService.new.send_notification(answer)
  end
end
