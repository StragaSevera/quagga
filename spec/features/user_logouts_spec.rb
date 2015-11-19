require 'rails_helper'

RSpec.feature "UserLogouts",
  %q{
    In order to switch accounts
    As an user
    I want to log out
  },
  type: :feature do

  given(:user) { create(:user) }

  scenario "User trying to log out" do
    user
    log_in_as(:user)

    click_link 'Выход'

    expect(page).to have_content "Выход из системы выполнен."
    expect(page).to have_content "Регистрация"
    expect(page).to have_content "Вход"
  end
end