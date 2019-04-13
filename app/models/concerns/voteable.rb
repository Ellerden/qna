module Voteable
  extend ActiveSupport::Concern

  included do
    has_many :votes, dependent: :destroy, as: :voteable
  end

  def score
    votes.sum(:value)
  end

  def upvote!(user)
    votes.create(user: user, value: 1)
  end

  def downvote!(user)
    votes.create(user: user, value: -1)
  end

  def cancel_votes(user)
    votes.where(user: user, voteable: self).delete_all
  end

  private

  def register_vote(user)
    votes.create(user: user)
  end
end
