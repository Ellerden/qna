# frozen_string_literal: true

class Answer < ApplicationRecord
  include Voteable
  include Commentable

  belongs_to :question, touch: true
  belongs_to :author, class_name: 'User'
  has_many :links, dependent: :destroy, as: :linkable
  has_many_attached :files
  has_one :award

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  validates :body, presence: true

  scope :sort_by_best, -> { order(best: :desc, created_at: :asc) }

  after_create :notify_subscribers, on: :create

  def rate_best
    previous_best = question.answers.where(best: true)
    transaction do
      unless previous_best == self
        reward
        previous_best.update(best: false)
        self.update!(best: true)
      end
    end
  end

  def notify_subscribers
    AnswerNotifyJob.perform_later(self)
  end

  private

  def reward
    award = question.award
    award.update!(answer: self, user: self.author) if award
  end
end
