class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :handle_oauth, except: :handle_email_user

  def facebook
  end

  def twitter
  end

  # Действие, которое вызывается после того, как пользователь
  # предоставит e-mail
  def handle_email_user
    redirect_to root_path unless session[:unactivated_auth]

    @unactivated_auth = Authorization.find(session[:unactivated_auth][:id])
    redirect_to root_path unless @unactivated_auth && @unactivated_auth.token_matches?(session[:unactivated_auth][:token])

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
        set_flash_message(:notice, :success, kind: action_name.capitalize) if is_navigational_format?
      else
        # Передаем параметры через сессию, а не через хиддены, во избежание
        # подделки злоумышленником
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
      params.permit(:email)
    end
end
