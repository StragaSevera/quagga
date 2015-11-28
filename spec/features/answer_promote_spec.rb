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
  given!(:answers) { create_list(:answer, 2, question: question, user: other) }

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
        visit question_path(question)

        within "#answer-#{answers[0].id}" do
          expect(page).to have_selector ".answer-normal"
          expect(page).not_to have_selector ".answer-best"

          click_link "answer-switch-#{answers[0].id}"

          expect(page).to have_css ".answer-normal"
          expect(page).not_to have_css ".answer-normal"

          expect(page).to have_selector ".answer-best"
        end

        within "#answer-#{answers[1].id}" do
          expect(page).to have_selector ".answer-normal"
          click_link "answer-switch-#{answers[1].id}"

          expect(page).to have_selector ".answer-best"
        end      

        within "#answer-#{answers[0].id}" do
          expect(page).to have_selector ".answer-normal"
        end 

        click_link "answer-switch-#{answers[1].id}"

        expect(page).not_to have_selector ".answer-best"        
      end
    end

    xcontext "as incorrect user" do
      before(:each) { log_in_as(other) }

      it_behaves_like "cannot switch best answer"
    end
  end

  xcontext "when logged out" do
    it_behaves_like "cannot switch best answer"  
  end
end
