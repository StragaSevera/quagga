module FeatureMacros
  def log_in_as(user, options = {})
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
  end

  def mock_auth_hash(provider, options = {})
    if options == :invalid
      OmniAuth.config.mock_auth[provider] = :invalid_credentials
    else
      hash = { 
        provider: provider.to_s, 
        uid: '123456',
        info: {
          name: options[:name] || "New User"
        }
      }
      hash[:info].merge!({ 
        email: options[:email] || "new@example.org",
      }) if provider == :facebook
      OmniAuth.config.mock_auth[provider] = OmniAuth::AuthHash.new(hash)
    end
  end

  def unmock_auth_hash(provider)
    OmniAuth.config.mock_auth[provider] = nil
  end
end