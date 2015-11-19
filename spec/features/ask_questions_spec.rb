require 'rails_helper'

RSpec.feature "AskQuestions", 
  %q{
    In order to get help
    As an user
    I want to ask question
  },
  type: :feature do

  context "when logged in" do
    given(:user) { create(:user) }
    before(:each) { log_in_as(user) }    

    scenario "User can ask correct questions" do
      visit new_question_path

      fill_in 'Заголовок', with: 'Rails autoloading'
      fill_in 'Вопрос', with: "How can I autoload a class defined in module?\nPlease, help!"
      click_button 'Задать вопрос'

      expect(page).to have_content 'Rails autoloading'
      expect(page).to have_content "How can I autoload a class defined in module?\nPlease, help!"
    end

    scenario "User cannot ask incorrect questions" do
      visit new_question_path

      fill_in 'Заголовок', with: 'Rails autoloading'
      fill_in 'Вопрос', with: ""
      click_button 'Задать вопрос'

      expect(page).to have_content 'Вопрос не может быть пустым'
    end
  end

  context "when logged out" do
    scenario "User cannot ask questions" do
      visit new_question_path

      expect(page).to have_content 'Вам необходимо войти в систему или зарегистрироваться.'
    end    
  end
end
