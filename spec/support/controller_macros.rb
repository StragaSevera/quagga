module ControllerMacros
  def log_in_as(user)
    @request.env['devise.mapping'] = Devise.mappings[:user]
    sign_in user
  end
end