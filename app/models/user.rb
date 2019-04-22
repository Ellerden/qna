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
  has_many :authorizations

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
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization

    email = auth.info[:email]
    user = User.where(email: email).first

    # если юзер не был найден, мы его создаем. а потом к юзеру (не важно это новый или мы его нашли)
    # создаем авторизации и возвращаем юзера
    unless user
      password = Devise.friendly_token[0, 20]
      user = User.create!(email: email, password: password, password_confirmation: password)
    end

    user.authorizations.create(provider: auth.provider, uid: auth.uid)
    user

   
    # if user
    #   user.create_authorization(auth)
    # else
    #   password = Devise.friendly_token[0, 20]
    #   user = User.create!(email: email, password: password, password_confirmation: password)
    #   user.create_authorization(auth)
    # end
    # user
  end

  def create_authorization(auth)
    self.authorizations.create(provider: auth.provider, uid: auth.uid)
  end
end
