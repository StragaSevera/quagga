class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # before_action заставляет Devise сбоить при переданных Invalid credentials
  def facebook
    process_oauth_hash
  end

  def twitter
    process_oauth_hash
  end

  # Действие, которое вызывается после того, как пользователь
  # предоставит e-mail
  def handle_email
    return redirect_to root_path unless session[:unactivated_auth]
    id = session[:unactivated_auth]["id"]
    token = session[:unactivated_auth]["token"]
    session[:unactivated_auth] = nil

    @auth = Authorization.find_by(id: id)
    return redirect_to root_path unless @auth && @auth.token_matches?(token)
    
    # Вся сложность с токенами может казаться излишней,
    # но это задел на отправку по почте.
    # Примерно в этом месте будет вставлена отправка письма,
    # а концовка действия будет после нажатия ссылки в письме
    if @user = @auth.connect_by_email(omniauth_callback_params[:email])
      AuthorizationMailer.confirm_email(@auth, token).deliver_now
      flash[:notice] = 'На вашу почту отправлено письмо. Перейдите по ссылке в нем, чтобы зарегистрироваться.'
      redirect_to root_path
    else
      flash[:error] = 'Ошибка подтверждения e-mail'
      redirect_to root_path
    end
  end

  def confirm_email
    @auth = Authorization.find_by(id: params[:id])
    token = params[:token]
    if @auth.token_matches?(token)
      @auth.activate!
      sign_in_verified_user(@auth.user, @auth.provider)
    else
      flash[:error] = 'Ошибка подтверждения e-mail'
      redirect_to root_path
    end
  end

  private
    # Какой-то "жирный" контроллер вышел. Что бы вырефакторить в модель?..
    def sign_in_verified_user(user, kind)
      sign_in_and_redirect user, event: :authentication
      set_flash_message(:notice, :success, kind: kind.capitalize) if is_navigational_format?
    end

    def process_oauth_hash
      auth_hash = request.env['omniauth.auth']
      @user = User.find_for_oauth(auth_hash)
      if @user && @user.persisted?
        sign_in_verified_user(@user, auth_hash.provider)
      else
        @unactivated_auth = Authorization.create_unactivated(auth_hash)
        redirect_to root_path unless @unactivated_auth

        session[:unactivated_auth] = {
          id: @unactivated_auth.id,
          token: @unactivated_auth.activation_token
        }

        flash[:notice] = 'Для завершения регистрации введите E-mail'
        render 'omniauth_callbacks/prompt_email'
      end      
    end

    def omniauth_callback_params
      params.require(:auth).permit(:email)
    end
end
