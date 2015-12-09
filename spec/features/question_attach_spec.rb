require 'feature_helper'

RSpec.feature "QuestionAttach", 
  %q{
    In order to get help
    As an user
    I want to attach files to question
  },
  type: :feature do

  given(:user) { create(:user) }
  before(:each) { log_in_as(user) }    

  scenario 'User adds file when asks question', js: true do
    visit new_question_path

    fill_in 'Заголовок', with: 'Rails autoloading'
    fill_in 'Вопрос', with: "How can I autoload a class defined in module?\nPlease, help!"

    click_link 'добавить файл'

    within '#question-attachments div:nth-last-child(2)' do
      attach_file 'Файл', "#{Rails.root}/spec/spec_helper.rb"
    end

    click_link 'добавить файл'

    within '#question-attachments div:nth-last-child(2)' do
      attach_file 'Файл', "#{Rails.root}/spec/rails_helper.rb"
    end

    click_button 'Задать вопрос'

    within '#question-block' do
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

    within '#question-block' do
      click_link 'редактировать'
      click_link 'добавить файл'
      attach_file 'Файл', "#{Rails.root}/Gemfile"
      click_button 'Изменить вопрос'
    end

    expect(page).to have_content "Вопрос был изменен!"
    expect(page).to have_content 'spec_helper.rb'
    expect(page).not_to have_content 'rails_helper.rb'
    expect(page).to have_content 'Gemfile'
  end
end
