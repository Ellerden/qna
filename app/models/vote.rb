class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :voteable, polymorphic: true

  validates :value, presence: true
end
