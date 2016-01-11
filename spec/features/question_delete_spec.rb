require 'feature_helper'

RSpec.feature "QuestionDelete", 
  %q{
    In order to undo asking
    As an user
    I want to delete question
  },
  type: :feature do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  context "when logged in" do
    context "as correct user" do
      background(:each) { log_in_as(user) }    

      scenario "User can delete questions" do
        create(:question_multi, user: user, title: 'Other title')
        visit question_path(question)
        
        within "#question-row-#{question.id}" do
          click_link 'удалить'
        end

        expect(page).to have_content "Вопрос был успешно удален!"
        expect(current_path).to eq questions_path
        expect(page).not_to have_content attributes_for(:question)[:body]
        expect(page).not_to have_content attributes_for(:question)[:title]
        expect(page).to have_content 'Other title'
      end
    end

    context "as incorrect user" do
      given(:other) { create(:user_multi) }
      background(:each) { log_in_as(other) }    

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