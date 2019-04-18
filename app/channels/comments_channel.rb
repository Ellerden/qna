class CommentsChannel < ApplicationCable::Channel
  def follow(data)
    Rails.logger.info 'Comment Followed'
    Rails.logger.info "IDDDD #{data['id']}"
    #question = Question.find(params[:id])
    question = Question.find(data['id']) if data['id']
    stream_for question
  end
end
