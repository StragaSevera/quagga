require 'feature_helper'

RSpec.feature "AnswerAttach", 
  %q{
    In order to promote answer
    As an user
    I want to vote for answer
  },
  type: :feature do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }
  before(:each) { log_in_as(user) }


  scenario 'User votes for answer', js: true do
    visit question_path(question)

    within '.answer-stats' do
      expect(page).to have_content "0"

      click_link '>'
      wait_for_ajax
      expect(page).not_to have_content "0"
      expect(page).to have_content "1"

      click_link '<'
      wait_for_ajax
      expect(page).not_to have_content "1"
      expect(page).to have_content "0"
    end
  end

  scenario 'User cannot vote twice in one direction', js: true do
    visit question_path(question)

    within '.answer-stats' do
      click_link '>'
      wait_for_ajax
      click_link '>'
      wait_for_ajax
      expect(page).not_to have_content "2"
      expect(page).to have_content "1"

      click_link '<'
      wait_for_ajax
      expect(page).not_to have_content "1"
      expect(page).to have_content "0"

      click_link '<'
      wait_for_ajax
      expect(page).not_to have_content "0"
      expect(page).to have_content "-1"

      click_link '<'
      wait_for_ajax
      expect(page).not_to have_content "-2"
      expect(page).to have_content "-1"   
    end
  end  
end
