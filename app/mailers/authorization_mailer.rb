class AuthorizationMailer < ApplicationMailer
  def confirm_email(auth, token)
    @auth = auth
    @token = token

    mail to: @auth.user.email, subject: "Подтверждение адреса электронной почты"
  end
end
