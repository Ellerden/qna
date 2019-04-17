class AnswersChannel < ApplicationCable::Channel
  def follow(data)
    Rails.logger.info 'Answer Followed'
    question = Question.find(data['id']) if data['id']
    stream_for question
  end
end
