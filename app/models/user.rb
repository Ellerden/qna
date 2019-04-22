class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, 
         :omniauthable, omniauth_providers: [:github]

  has_many :questions, class_name: 'Question', foreign_key: :author_id,
                           dependent: :destroy
  has_many :answers, class_name: 'Answer', foreign_key: :author_id,
                           dependent: :destroy
  has_many :comments, class_name: 'Comment', foreign_key: :author_id,
                           dependent: :destroy            
  has_many :awards
  has_many :votes
  has_many :authorizations, dependent: :destroy

  def author_of?(resource)
    self.id == resource.author_id
  end

  # обращение к базе 1
  def voted_for?(resource)
    votes.where(voteable: resource).any?
  end

  # обращение к базе 2 - подумать может можно минимизировать обращения
  def previous_vote_value(resource)
    votes.where(voteable: resource).pluck(:value).first
  end

  def self.find_for_oauth(auth)
    FindForOauthService.new(auth).call
  end
end
