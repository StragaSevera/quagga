module CommonMacros
  def log_in_as(user, options = {})
    if feature_test?
      attrs = attributes_for(user)
      email = options[:email] || attrs[:email]
      password = options[:password] || attrs[:password]

      visit new_user_session_path

      fill_in 'E-mail', with: email
      fill_in 'Пароль', with: password

      click_on 'Войти'
    else
      @user = create(user)
      @request.env['devise.mapping'] = Devise.mappings[:user]
      sign_in @user
    end
  end

  private
    def feature_test?
      defined?(visit)
    end
end