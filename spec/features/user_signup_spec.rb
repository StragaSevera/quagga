require 'feature_helper'

RSpec.feature "UserSignup", 
  %q{
    In order to be able to log in
    As an user
    I want to sign up
  },
  type: :feature do

  scenario "Sign up with correct parameters" do
    visit signup_path

    fill_in 'Ник', with: "Test user"
    fill_in 'E-mail', with: "test@example.org"
    fill_in 'Пароль', with: "password"
    fill_in 'Подтверждение пароля', with: "password"
    click_on 'Зарегистрироваться'

    expect(page).to have_content "Добро пожаловать! Вы успешно зарегистрировались."
  end

  scenario 'Incorrect user trying to log in' do
    visit signup_path

    fill_in 'Ник', with: "Test user"
    fill_in 'E-mail', with: "test@example"
    fill_in 'Пароль', with: "password"
    fill_in 'Подтверждение пароля', with: "password"
    click_on 'Зарегистрироваться'

    expect(page).to have_content 'E-mail имеет неверное значение'
  end
end