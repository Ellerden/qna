class QuestionsChannel < ApplicationCable::Channel
  def follow
    Rails.logger.info 'Follow'
    stream_from 'questions'
  end
end
