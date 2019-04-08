module Voteable
  extend ActiveSupport::Concern

  included do
    has_many :votes, dependent: :destroy, as: :voteable
  end

  def score
    votes.sum(:value)
  end

  def register_vote(user)
    votes.create(user: user)
  end

  def cancel_votes(user)
    votes.where(user: user, voteable: self).delete_all
  end
end
