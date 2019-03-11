# frozen_string_literal: true

class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :author, class_name: 'User'

  validates :body, presence: true

  scope :sort_by_best, -> { order(best: :desc, created_at: :asc) }

  def rate_best
    previous_best = question.answers.where(best: true)
    transaction do
      unless previous_best == self
        previous_best.update(best: false)
        self.update(best: true)
      end
    end
  end
end
