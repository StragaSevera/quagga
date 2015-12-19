require 'feature_helper'

RSpec.feature "AnswerEdit", 
  %q{
    In order to fix mistakes
    As an user
    I want to edit question
  },
  type: :feature do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  shared_examples_for "cannot edit answer" do
    scenario "has not edit link" do
      visit question_path(question)

      within "#answer-#{answer.id}" do
        expect(page).not_to have_content "редактировать"
      end      
    end    
  end

  describe "when logged in" do
    context "as correct user", js: true do
      background(:each) { log_in_as(user) }

      scenario "User can edit with correct data" do
        visit question_path(question)

        within "#answer-#{answer.id}" do
          click_link "редактировать"
          fill_in 'Ответ', with: "It's a very new answer!!!"
          click_button 'Отправить'
          

          expect(page).not_to have_content attributes_for(:answer)[:body]
          expect(page).not_to have_selector '#answer_body'

          within '.answer-row' do
            expect(page).to have_content "It's a very new answer!!!"
          end
        end

        expect(page).to have_content "Ответ был изменен!"
      end

      scenario "User cannot edit with incorrect data" do
        visit question_path(question)

        within "#answer-#{answer.id}" do
          click_link "редактировать"
          fill_in 'Ответ', with: ""
          click_button 'Отправить'

          expect(page).to have_content attributes_for(:answer)[:body]
          expect(page).to have_selector '#answer_body'

          within '.answer-row' do
            expect(page).not_to have_content "It's a very new answer!!!"
          end

          expect(page).to have_content 'Ответ не может быть пустым'
        end

        expect(page).not_to have_content "Ответ был изменен!"
      end
    end

    context "as incorrect user" do
      given (:other) { create(:user_multi) }
      background(:each) { log_in_as(other) }

      it_behaves_like "cannot edit answer"
    end
  end

  context "when logged out" do
    it_behaves_like "cannot edit answer"  
  end
end
