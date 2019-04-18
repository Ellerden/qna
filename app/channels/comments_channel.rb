class CommentsChannel < ApplicationCable::Channel
  def follow(data)
    Rails.logger.info 'Comment Followed'
    question = Question.find(data['id']) if data['id']
    stream_for question
  end
end
