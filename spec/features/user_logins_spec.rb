require 'rails_helper'

RSpec.feature "UserLogins", 
  %q{
    In order to ask questions
    As an user
    I want to sign in
  },
  type: :feature do

  given(:user) { create(:user) }

  scenario "Correct user trying to log in" do
    user
    log_in_as(:user)

    expect(page).to have_content 'Добро пожаловать, #{user.name}!'
  end

  scenario 'Incorrect user trying to log in' do
    log_in_as(:user_incorrect)

    expect(page).to have_content 'Неправильный email или пароль. Пожалуйста, перепроверьте данные!'
  end
end
