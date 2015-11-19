module CommonMacros
  def log_in_as(user, options = {})
    if feature_test?
      if user && ( user.is_a? Symbol )
        attrs = attributes_for(user)
        email = options[:email] || attrs[:email]
        password = options[:password] || attrs[:password]   
      else
        email = options[:email] || user.email
        password = options[:password] || user.password
      end

      visit new_user_session_path

      fill_in 'E-mail', with: email
      fill_in 'Пароль', with: password

      click_on 'Войти'
    else
      @request.env['devise.mapping'] = Devise.mappings[:user]
      sign_in user
    end
  end

  private
    def feature_test?
      defined?(visit)
    end
end