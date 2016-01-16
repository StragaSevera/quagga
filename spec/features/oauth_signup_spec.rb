require 'feature_helper'

RSpec.feature "OauthSignup", 
  %q{
    In order to make questions
    As an user
    I want to signup by oauth
  },
  type: :feature do

  given(:user) { create(:user) }

  feature "signing in by Facebook" do
    context "with valid information" do
      scenario "enters site with existing user" do
        mock_auth_hash(:facebook, email: user.email)
        visit new_user_session_path
        click_link "Зайти через Facebook"
        expect(page).to have_content "Вход в систему выполнен с учётной записью Facebook."
        expect(page).to have_content user.name
      end

      scenario "enters site with new user" do
        mock_auth_hash(:facebook, email: "new@email.com", name: "Jane Doe")
        visit new_user_session_path
        click_link "Зайти через Facebook"
        expect(page).to have_content "Вход в систему выполнен с учётной записью Facebook."
        expect(page).to have_content "Jane Doe"
      end
    end

    context "with invalid information" do
      scenario "does not enter site" do
        mock_auth_hash(:facebook, :invalid)
        visit new_user_session_path
        click_link "Зайти через Facebook"
        expect(page).to have_content "Вы не можете войти в систему с учётной записью Facebook. Сервер Facebook вернул следующий ответ: \"Invalid credentials\"."
      end
    end
  end


  feature "signing in by Twitter" do
    context "with valid information" do
      background do
        clear_emails
      end

      scenario "enters site with existing user" do
        mock_auth_hash(:twitter)
        visit new_user_session_path
        click_link "Зайти через Twitter"
        fill_in "E-mail", with: user.email
        click_button "Отправить"
        open_email user.email
        current_email.click_link 'Подтвердить e-mail'
        expect(page).to have_content "Вход в систему выполнен с учётной записью Twitter."
        expect(page).to have_content user.name
      end

      scenario "enters site with new user" do
        mock_auth_hash(:twitter, name: "Jane Doe")
        visit new_user_session_path
        click_link "Зайти через Twitter"
        fill_in "E-mail", with: "newauth@example.org"
        click_button "Отправить"
        open_email "newauth@example.org"
        current_email.click_link 'Подтвердить e-mail'
        expect(page).to have_content "Вход в систему выполнен с учётной записью Twitter."
        expect(page).to have_content "Jane Doe"
      end
    end

    context "with invalid information" do
      scenario "does not enter site" do
        mock_auth_hash(:twitter, :invalid)
        visit new_user_session_path
        click_link "Зайти через Twitter"
        expect(page).to have_content "Вы не можете войти в систему с учётной записью Twitter. Сервер Twitter вернул следующий ответ: \"Invalid credentials\"."
      end
    end
  end
end
