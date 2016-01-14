class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # before_action заставляет Devise сбоить при переданных Invalid credentials
  def facebook
    handle_oauth
  end

  def twitter
    handle_oauth
  end

  # Действие, которое вызывается после того, как пользователь
  # предоставит e-mail
  def handle_email
    redirect_to root_path unless session[:unactivated_auth]
    id = session[:unactivated_auth]["id"]
    token = session[:unactivated_auth]["token"]
    session[:unactivated_auth] = nil

    @unactivated_auth = Authorization.find(id)
    redirect_to root_path unless @unactivated_auth && @unactivated_auth.token_matches?(token)

    auth_hash = @unactivated_auth.generate_hash(omniauth_callback_params[:email])
    process_oauth_hash(auth_hash)
  end

  private
    def handle_oauth
      auth_hash = request.env['omniauth.auth']
      process_oauth_hash(auth_hash)
    end

    def process_oauth_hash(auth_hash)
      @user = User.find_for_oauth(auth_hash)
      if @user && @user.persisted?
        sign_in_and_redirect @user, event: :authentication
        set_flash_message(:notice, :success, kind: auth_hash.provider.capitalize) if is_navigational_format?
      else
        # Передаем параметры через сессию, а не через хиддены, во избежание
        # подделки злоумышленником
        @unactivated_auth = Authorization.create_unactivated(auth_hash)
        redirect_to root_path unless @unactivated_auth
        @unactivated_auth.activation_token
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
