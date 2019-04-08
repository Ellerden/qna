module Voted
  extend ActiveSupport::Concern

  VALUES = { up: 1, down: -1, cancel: 0 }.freeze

  included do
    before_action :set_resource, only: [:upvote, :downvote]
  end

  def upvote
    used_as_cancelation?(:up) ? vote(:cancel) : vote(:up)
  end

  def downvote
    used_as_cancelation?(:down) ? vote(:cancel) : vote(:down)
  end

  private

  def model_klass
    controller_name.classify.underscore
  end

  def set_resource
    @resource = send(model_klass)
  end

  def used_as_cancelation?(type)
    previous_vote_value = current_user.previous_vote_value(@resource)
    true if previous_vote_value.present? && previous_vote_value != VALUES[type]
  end

  def vote(type)
    # в базе может быть только один предыдущий голос. (остальные удаляются, если были использованы для отмены)
    unless (current_user.voted_for?(@resource) && type != :cancel) || current_user.author_of?(@resource)
      vote = @resource.register_vote(current_user)

      case type
      when :up
        vote.upvote!
      when :down
        vote.downvote!
      when :cancel
        @resource.cancel_votes(current_user)
      end
    end

    render json: { score: @resource.score }
  end
end
