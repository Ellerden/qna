# frozen_string_literal: true

class Question < ApplicationRecord
  include Voteable
  include Commentable

  has_many :answers, dependent: :destroy
  belongs_to :author, class_name: 'User'
  has_many :links, dependent: :destroy, as: :linkable
  has_one :award, dependent: :destroy
  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :award, reject_if: :all_blank

  validates :title, :body, presence: true

  #after_create :calculate_reputation

  scope :today, -> { where(created_at: 24.hours.ago..Time.now) }

  private

  # def calculate_reputation
  #   ReputationJob.perform_later(self)
  # end
end
