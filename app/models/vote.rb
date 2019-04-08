class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :voteable, polymorphic: true

  validates :value, presence: true

  def upvote!
    vote!(1)
  end

  def downvote!
    vote!(-1)
  end

  private

  def vote!(value)
    update!(value: value)
  end
end
