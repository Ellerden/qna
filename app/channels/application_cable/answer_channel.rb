class AnswerChannel < ActionCable::Channel::Channel
  def follow
    # stream_from "questions"
  end
end
