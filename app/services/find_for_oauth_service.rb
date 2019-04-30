class FindForOauthService
  attr_reader :auth

  def initialize(auth)
    @auth = auth
  end

  def call
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).where.not(confirmed_at: nil).first

    return authorization.user if authorization
    return unless auth.info && auth.info[:email]

    email = auth.info[:email]
    # если юзер не был найден, мы его создаем. а потом к юзеру (не важно это новый или мы его нашли)
    # создаем авторизации и возвращаем юзера
    user = User.find_or_init_skip_confirmation(email)
    user.authorizations.create(provider: auth.provider, uid: auth.uid, linked_email: email, confirmed_at: Time.now)
    user
  end
end
