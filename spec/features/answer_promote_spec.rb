require 'feature_helper'

RSpec.feature "AnswerPromote", 
  %q{
    In order to be grateful
    As an user
    I want to promote answer
  },
  type: :feature do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answers) { create_list(:answer, 2, question: question, user: user) }

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
      before(:each) { log_in_as(user) }

      scenario "User can promote answer" do
        visit question_path(question)

        within "#answer-#{answers[0].id}" do
          expect(page).to have_selector ".answer-normal"
          click_link "answer-promote-#{answers[0].id}"

          expect(page).to have_selector ".answer-best"
        end
      end

      xscenario "User cannot edit with incorrect data" do
        visit question_path(question)

        within "#answer-#{answer.id}" do
          click_link "редактировать"
          fill_in 'Ответ', with: ""
          click_button 'Изменить ответ'

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

    xcontext "as incorrect user" do
      given (:other) { create(:user_multi) }
      before(:each) { log_in_as(other) }

      it_behaves_like "cannot edit answer"
    end
  end

  xcontext "when logged out" do
    it_behaves_like "cannot edit answer"  
  end
end
