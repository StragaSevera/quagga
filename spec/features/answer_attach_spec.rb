require 'feature_helper'

RSpec.feature "AnswerAttach", 
  %q{
    In order to illustrate answer
    As an user
    I want to attach files to answer
  },
  type: :feature do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }
  before(:each) { log_in_as(user) }


  scenario 'User adds file when makes answer', js: true do
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
      end
    end
  end

  scenario 'User deletes file from answer', js: true do
    attachment = create(:attachment, attachable: answer)
    visit question_path(question)

    within '#answers-block' do
      within '.attachments-list' do
        # Не уверен, что привязываться к attachment хорошо,
        # но хардкодить имя файла - явно не очень правильно,
        # а из factory_girl можно выцарапать лишь tempfile,
        # который не имеет свойства "имя файла"
        expect(page).to have_content attachment.file.identifier

        first("li").click_link("удалить")
      end
    end

    expect(page).to have_content "Файл был удален!"
    expect(page).not_to have_content attachment.file.identifier
  end

  scenario 'User attaches file when edits answer', js: true do
    visit question_path(question)

    within '#answers-block' do
      click_link 'редактировать'

      click_link 'добавить файл'
      attach_file 'Файл', "#{Rails.root}/Gemfile"

      click_button 'Отправить'
    end

    expect(page).to have_content "Ответ был изменен!"

    # ВНЕЗАПНО проблема решилась сама собой после рефакторинга.
    # Не имею ни малейшего понятия, откуда она взялась и куда делась =-)
    expect(page).to have_content 'Gemfile'
  end
end
