# Preview all emails at http://localhost:3000/rails/mailers/authorization_mailer
class AuthorizationMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/authorization_mailer/confirm_email
  def confirm_email
    user = FactoryGirl.create(:user)
    auth = FactoryGirl.create(:authorization, user: user)
    auth.activation_token = Authorization.generate_token
    AuthorizationMailer.confirm_email(auth)
    auth.destroy!
    user.destroy!
  end

end
