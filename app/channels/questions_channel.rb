class QuestionsChannel < ApplicationCable::Channel
  def follow
    Rails.logger.info 'Question Followed'
    stream_from 'questions'
  end
end
