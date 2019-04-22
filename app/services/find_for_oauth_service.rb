class FindForOauthService
  attr_reader :auth

  def initialize(auth)
    @auth = auth
  end

  def call
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
  end
end
