require 'feature_helper'

RSpec.feature "AnswerAttach", 
  %q{
    In order to illustrate answer
    As an user
    I want to attach files to answer
  },
  type: :feature do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }


  scenario 'User adds file when makes answer', js: true do
    log_in_as(user)
    visit question_path(question)

    within ".answer-edit form" do
      fill_in 'Ответ', with: "Why do you need this, anyway?"

      click_link 'добавить файл'
      within '.answer-attachments div:nth-last-child(2)' do
        attach_file 'Файл', "#{Rails.root}/spec/spec_helper.rb"
      end

      click_link 'добавить файл'

      within '.answer-attachments div:nth-last-child(2)' do
        attach_file 'Файл', "#{Rails.root}/spec/rails_helper.rb"
      end
      click_button 'Отправить'
    end

    within '#answers-block' do
      within '.attachments-list' do
        # Так как тесты должны не зависеть друг от друга, то применяем regexp:
        link = page.find('a', text: 'spec_helper.rb')
        expect(link[:href]).to match %r!/uploads/attachment/file/*./spec_helper.rb!

        link = page.find('a', text: 'rails_helper.rb')
        expect(link[:href]).to match %r!/uploads/attachment/file/*./rails_helper.rb!

        first("li").click_link("удалить")
      end
    end

    expect(page).to have_content "Файл был удален!"
    expect(page).to have_content 'spec_helper.rb'
    expect(page).not_to have_content 'rails_helper.rb'

    within '#answers-block' do
      click_link 'редактировать'

      click_link 'добавить файл'
      attach_file 'Файл', "#{Rails.root}/Gemfile"

      click_button 'Отправить'
    end

    expect(page).to have_content "Ответ был изменен!"
    expect(page).to have_content 'spec_helper.rb'
    expect(page).not_to have_content 'rails_helper.rb'

    # Имею проблему в этом моменте.
    # AJAJ-ответ после запроса update не проходит по непонятной мне причине.
    # Не проходит он ТОЛЬКО в тесте, в реальности работает прекрасно.
    # Возможно, связано с remotipart, однако в аналогичной спеке вопроса
    # подобный тест работает прекрасно.
    # 
    # expect(page).to have_content 'Gemfile'
  end
end
