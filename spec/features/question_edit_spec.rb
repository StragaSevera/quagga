require 'feature_helper'

RSpec.feature "QuestionEdit", 
  %q{
    In order to fix mistakes
    As an user
    I want to edit question
  },
  type: :feature do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  shared_examples_for "cannot edit question" do
    scenario "has not edit link" do
      visit question_path(question)

      within '#question-block' do
        expect(page).not_to have_content "редактировать"
      end      
    end    
  end

  describe "when logged in" do
    context "as correct user", js: true do
      before(:each) { log_in_as(user) }    

      scenario "User can edit with correct data" do
        visit question_path(question)

        within '#question-block' do
          click_link "редактировать"
          fill_in 'Заголовок', with: 'New title'
          fill_in 'Вопрос', with: "It's a very new body!!!"
          click_button 'Изменить вопрос'

          expect(page).not_to have_content attributes_for(:question)[:title]
          expect(page).not_to have_content attributes_for(:question)[:body]
          expect(page).not_to have_selector '#question_body'
          expect(page).not_to have_selector '#question_title'

          within '.question-row' do
            expect(page).to have_content 'New title'
            expect(page).to have_content "It's a very new body!!!"
          end
        end
      end

      scenario "User cannot edit with incorrect data" do
        visit question_path(question)

        within '#question-block' do
          click_link "редактировать"
          fill_in 'Заголовок', with: 'New title'
          fill_in 'Вопрос', with: ""
          click_button 'Изменить вопрос'


          expect(page).to have_selector '#question_body'
          expect(page).to have_selector '#question_title'

          within '.question-row' do
            expect(page).to have_content attributes_for(:question)[:title]
            expect(page).to have_content attributes_for(:question)[:body]
            expect(page).not_to have_content 'New title'
          end
        end

        expect(page).to have_content 'Вопрос не может быть пустым'
      end
    end

    context "as incorrect user" do
      given (:other) { create(:user_multi) }
      before(:each) { log_in_as(other) }

      it_behaves_like "cannot edit question"
    end
  end

  context "when logged out" do
    it_behaves_like "cannot edit question"  
  end
end
