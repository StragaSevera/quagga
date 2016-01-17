class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_authorization_check
  include OmniauthSigned

  # before_action заставляет Devise сбоить при переданных Invalid credentials
  def facebook
    process_oauth_hash
  end

  def twitter
    process_oauth_hash
  end

  private
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
end
