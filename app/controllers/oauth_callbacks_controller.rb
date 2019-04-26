class OauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    sign_in_via_provider('Github')
  end

  def vkontakte
    sign_in_via_provider('Vkontakte')
  end

  def facebook
    #render json: request.env['omniauth.auth']
    sign_in_via_provider('Facebook')
  end

  def verify_email
    authorization = Authorization.find_by_confirmation_token(params[:token])
    if authorization
      authorization.activate_email 
      redirect_to new_user_session_path, notice: "Your account was succesfully verified. Now you can log in via #{authorization.provider.capitalize}"
    else
      redirect_to new_user_session_path, alert: "Sorry. Something went wrong, try confirming the mail again."
    end
  end

  def confirm_email
    pending_user = User.find_or_init_skip_confirmation(params[:email])
    if pending_user 
      aut = pending_user.authorizations.create!(provider: session[:auth]['provider'], uid: session[:auth]['uid'], 
                                                linked_email: params[:email], confirmation_token: Devise.friendly_token[0, 20],
                                                confirmation_sent_at: Time.now)
      
      OauthMailer.send_confirmation_letter(aut).deliver_now
      redirect_to root_path, notice: "Great! Now confirm your email, we've sent you a letter!"
    else
      render 'omniauth_callbacks/confirm_email', alert: "We couldn't verify your email, please try again later"
    end 
  end

  private

  def sign_in_via_provider(provider)
    @user = User.find_for_oauth(request.env['omniauth.auth'])

    #Если у нас уже была такая авторизация без e-mail и мы все записали в базу или это первая авторизация без и-мейла
    unless @user || has_email?
      session[:auth] = { uid: request.env['omniauth.auth']['uid'], provider: request.env['omniauth.auth']['provider'] }
      render 'omniauth_callbacks/confirm_email', locals: { auth: Authorization.new }
    end

    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: provider) if is_navigational_format?
    else
      redirect_to root_path, alert: "Something went wrong, we couldn't sign you in via #{provider}" if has_email? 
    end
  end

  def has_email?
    request.env['omniauth.auth']['info']['email'].present?
  end

  # def auth
  #   request.env['omniauth.auth'] || OmniAuth::AuthHash.new(params['auth'])
  # end
end
