class OmniauthEmailController < ApplicationController
  skip_authorization_check 
  skip_before_action :authenticate_user!
  include OmniauthSigned

  def handle_email
    return redirect_to root_path unless session[:unactivated_auth]
    id = session[:unactivated_auth]["id"]
    token = session[:unactivated_auth]["token"]
    session[:unactivated_auth] = nil

    @auth = Authorization.find_by(id: id)
    return redirect_to root_path unless @auth && @auth.token_matches?(token)
    
    if @user = @auth.connect_by_email(omniauth_email_params[:email])
      AuthorizationMailer.confirm_email(@auth, token).deliver_later
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
    def omniauth_email_params
      params.require(:auth).permit(:email)
    end
end
