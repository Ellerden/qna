class AnswersChannel < ApplicationCable::Channel
  def follow(data)
    Rails.logger.info 'Answer Followed'
    question = Question.find(data['id'])
    #Rails.logger.info "QQ - #{data['id']}"
    stream_for question
  end
end
