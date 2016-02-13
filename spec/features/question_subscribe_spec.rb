require 'feature_helper'

RSpec.feature "QuestionSubscribe", 
  %q{
    In order to receive updates
    As an user
    I want to subscribe to question
  },
  type: :feature do

  given(:user) { create(:user) }
  given(:other) { create(:user_multi) }
  given(:question) { create(:question, user: user) }

  scenario "correctly subscribes and unsubscribes", js: true do
    log_in_as(user)
    visit new_question_path

    fill_in 'Заголовок', with: 'Rails autoloading'
    fill_in 'Вопрос', with: "How can I autoload a class defined in module?\nPlease, help!"
    click_button 'Задать вопрос'

    expect(page).not_to have_content 'подписаться на вопрос' 
    click_link 'отписаться от вопроса'
    wait_for_ajax

    expect(page).not_to have_content 'отписаться от вопроса'
    click_link 'подписаться на вопрос'
    wait_for_ajax

    expect(page).not_to have_content 'подписаться на вопрос' 
    expect(page).to have_content 'отписаться от вопроса'
  end

  scenario "correctly receives notification", js: true do
    expect(user).to be_subscribed(question)
    log_in_as(other)
    visit question_path(question)
    fill_in 'Ответ', with: "I want to send you e-mail!"

    perform_enqueued_jobs do
      click_button 'Отправить'
      sleep 0.5
      open_email user.email
      expect(current_email).to have_content("I want to send you e-mail!")
      expect(current_email).to have_content(user.name)
      expect(current_email).to have_content(other.name)
      expect(current_email).to have_content(question.title)
    end
  end
end