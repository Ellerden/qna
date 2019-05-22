class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, 
         :confirmable, 
         :omniauthable, omniauth_providers: %i[github facebook vkontakte]

  has_many :questions, class_name: 'Question', foreign_key: :author_id,
                           dependent: :destroy
  has_many :answers, class_name: 'Answer', foreign_key: :author_id,
                           dependent: :destroy
  has_many :comments, class_name: 'Comment', foreign_key: :author_id,
                           dependent: :destroy            
  has_many :awards
  has_many :votes
  has_many :authorizations, dependent: :destroy
  has_many :subscriptions, dependent: :destroy

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

  def self.find_or_init_skip_confirmation(email)
    password = Devise.friendly_token[0, 20]
    user = User.find_or_initialize_by(email: email) do |u|
      u.password = password
      u.password_confirmation = password
    end

    user.skip_confirmation!
    user if user.save
  end
end
