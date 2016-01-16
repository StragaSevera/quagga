module OmniauthSigned
  extend ActiveSupport::Concern

  included do
    helper_method :sign_in_verified_user
  end

  def sign_in_verified_user(user, kind)
    sign_in_and_redirect user, event: :authentication
    flash[:notice] = I18n.t('devise.omniauth_callbacks.success', kind: kind.capitalize) if is_navigational_format?
  end
end