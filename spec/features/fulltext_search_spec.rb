require 'feature_helper'

RSpec.feature "FulltextSearch", 
  %q{
    In order to find item
    As an guest
    I want to make fulltext search
  },
  type: :feature do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user, title: "Good title",  body: "Searchable text") }
  given!(:answer) { create(:answer, user: user, question: question, body: "Searchable answer") }
  given!(:answer_unsearchable) { create(:answer, user: user, question: question, body: "No way. No search for you!") }
  given!(:comment) { create(:comment, user: user, commentable_type: "Question", commentable_id: question.id, body: "Searchable comment") }

  scenario "User can find correct items with max scope", js: true do
    index
    visit search_path
    fill_in "Текст:", with: "Searchable"
    select "везде", from: "Область поиска:"

    click_button("Отправить")

    expect(page).to have_content "вопрос \"Good title\""
    expect(page).to have_content "Searchable text"
    expect(page).to have_content "ответ к \"Good title\""
    expect(page).to have_content "Searchable answer"
    expect(page).to have_content "комментарий к \"Good title\""
    expect(page).to have_content "Searchable comment"

    expect(page).not_to have_content "No way. No search for you!"
  end

  scenario "User can find correct items with local scope", js: true do
    index
    visit search_path
    fill_in "Текст:", with: "Searchable"
    select "ответы", from: "Область поиска:"

    click_button("Отправить")

    expect(page).not_to have_content "вопрос \"Good title\""
    expect(page).not_to have_content "Searchable text"
    expect(page).to have_content "ответ к \"Good title\""
    expect(page).to have_content "Searchable answer"
    expect(page).not_to have_content "комментарий к \"Good title\""
    expect(page).not_to have_content "Searchable comment"

    expect(page).not_to have_content "No way. No search for you!"
  end
end