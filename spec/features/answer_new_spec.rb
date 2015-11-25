require 'rails_helper'

RSpec.feature "AnswerNew", 
  %q{
    In order to get help
    As an user
    I want to ask answer
  },
  type: :feature do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  context "when logged in" do
    before(:each) { log_in_as(user) }    

    scenario "User can make correct answers" do
      visit question_path(question)

      fill_in 'Ваш ответ', with: "No way. It cannot exist."
      click_button 'Ответить'

      expect(page).to have_content "No way. It cannot exist."
    end

    scenario "User cannot make incorrect answers" do
      visit question_path(question)

      click_button 'Ответить'

      expect(page).to have_content 'Ответ не может быть пустым'
    end
  end

  context "when logged out" do
    scenario "User cannot make answers" do
      visit question_path(question)

      expect(page).not_to have_content 'Ваш ответ'
    end    
  end
end
