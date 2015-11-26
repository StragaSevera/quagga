require 'feature_helper'

RSpec.feature "AnswerDelete", 
  %q{
    In order to undo answering
    As an user
    I want to delete answer
  },
  type: :feature do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, user: user, question: question) }

  context "when logged in" do
    context "as correct user" do
      before(:each) { log_in_as(user) }    

      scenario "User can delete answers" do
        visit question_path(question)

        within "#answer-#{answer.id}" do
          click_link 'удалить'
        end

        expect(page).to have_content "Ответ был удален!"
        expect(page).not_to have_content attributes_for(:answer)[:body]
      end
    end

    context "as incorrect user" do
      given(:other) { create(:user_multi) }
      before(:each) { log_in_as(other) }    

      scenario "User cannot delete questions" do
        visit question_path(question)

        expect(page).not_to have_content 'удалить'
      end
    end
  end

  context "when logged out" do
    scenario "User cannot delete questions" do
      visit question_path(question)

      expect(page).not_to have_content 'удалить'
    end 
  end
end