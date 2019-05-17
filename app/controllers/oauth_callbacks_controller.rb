class OauthCallbacksController < Devise::OmniauthCallbacksController
  skip_authorization_check
  
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
      aut = Authorization.where(provider: session[:auth]['provider'], uid: session[:auth]['uid'], linked_email: params[:email])
                         .first_or_initialize do |auth|
        auth.user = pending_user
        auth.confirmation_token = Devise.friendly_token[0, 20]
        auth.confirmation_sent_at = Time.now.utc
      end

      if aut.save
        OauthMailer.send_confirmation_letter(aut).deliver_now
        redirect_to root_path, notice: "Great! Now confirm your email, we've sent you a letter!"
      else
        redirect_to root_path, alert: "Something went wrong. Please try again later or use another sign in method"
      end
    end
  end

  private

  def sign_in_via_provider(provider)
    @user = User.find_for_oauth(request.env['omniauth.auth'])

    #Если это первая авторизация без email 
    #(если уже не первая и все подтверждено - то связка есть в базе, поэтому мы нашли user)
    unless @user || has_email?
      session[:auth] = { uid: request.env['omniauth.auth']['uid'], provider: request.env['omniauth.auth']['provider'] }
      render 'omniauth_callbacks/confirm_email'
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
end
