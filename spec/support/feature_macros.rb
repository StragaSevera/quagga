module FeatureMacros
  def sign_in(user)
    attrs = attributes_for(user)
    visit new_user_session_path
    fill_in 'Email', with: attrs[:email]
    fill_in 'Пароль', with: attrs[:password]
    click_on 'Войти'
  end
end