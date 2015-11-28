require 'feature_helper'

RSpec.feature "AnswerPromote", 
  %q{
    In order to be grateful
    As an user
    I want to promote answer
  },
  type: :feature do

  given(:user) { create(:user) }
  given(:other) { create(:user_multi) }
  given(:question) { create(:question, user: user) }
  given!(:answers) { create_list(:answer, 3, question: question, user: other) }

  shared_examples_for "cannot switch best answer" do
    scenario "has not edit link" do
      visit question_path(question)
      expect(page).not_to have_link "answer-switch-#{answers[0].id}"
    end    
  end

  describe "when logged in" do
    context "as correct user", js: true do
      before(:each) { log_in_as(user) }

      scenario "User can switch best answer" do
        answers[1].promote!
        visit question_path(question)

        # Проверяем, чтобы первым шел принятый ответ
        within("#answers-block") do
          within("div.answer-subblock:first-of-type") do
            expect(page).not_to have_css ".answer-normal"
            expect(page).to have_selector ".answer-best"
          end
        end

        within "#answer-#{answers[0].id}" do
          expect(page).to have_selector ".answer-normal"
          expect(page).not_to have_selector ".answer-best"

          click_link "answer-switch-#{answers[0].id}"

          # Напоролся здесь на баг с race condition,
          # который может привести к false positive.
          # Поэтому выжидаем время.
          sleep 0.05

          expect(page).not_to have_css ".answer-normal"
          expect(page).to have_selector ".answer-best"
        end

        within "#answer-#{answers[2].id}" do
          expect(page).to have_selector ".answer-normal"
          expect(page).not_to have_selector ".answer-best"

          click_link "answer-switch-#{answers[2].id}"
          sleep 0.05

          expect(page).not_to have_css ".answer-normal"
          expect(page).to have_selector ".answer-best"
        end      

        within "#answer-#{answers[0].id}" do
          expect(page).to have_selector ".answer-normal"
          expect(page).not_to have_selector ".answer-best"
        end 

        click_link "answer-switch-#{answers[2].id}"
        sleep 0.05

        expect(page).not_to have_selector ".answer-best"        
      end
    end

    context "as incorrect user" do
      before(:each) { log_in_as(other) }

      it_behaves_like "cannot switch best answer"
    end
  end

  context "when logged out" do
    it_behaves_like "cannot switch best answer"  
  end
end
