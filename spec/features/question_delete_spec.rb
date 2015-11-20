require 'rails_helper'

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
      before(:each) { log_in_as(user) }    

      scenario "User can delete questions" do
        visit question_path(question)

        click_link 'удалить'

        expect(page).to have_content "Вопрос был удален!"
        expect(page).not_to have_content 'Rails autoloading'
        expect(page).not_to have_content "How can I autoload a class defined in module?\nPlease, help!"
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