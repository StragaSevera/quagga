require 'feature_helper'

RSpec.feature "QuestionsList", 
  %q{
    In order to seek help
    As an user
    I want to list questions
  },
  type: :feature do
  
  scenario "User can list questions" do
    user = create(:user)

    # Гугл показал, что полагаться на то, что сиквенс начнется с определенного номера
    # суть антипаттерн
    1.upto(6) { |n| create(:question_multi, user: user, title: "##{n} question") }
    visit questions_path
    # Тестируем с учетом пагинации и порядка
    6.downto(4) do |n| 
      within("div.question-subblock:nth-of-type(#{7-n})") do
        expect(page).to have_content "##{n} question"
      end
    end 
    3.downto(1) { |n| expect(page).not_to have_content "##{n} question" }

    click_link '2'
    3.downto(1) do |n| 
      within("div.question-subblock:nth-of-type(#{4-n})") do
        expect(page).to have_content "##{n} question"
      end
    end     
  end  
end