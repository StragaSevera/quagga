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


  scenario 'User adds file when asks question' do
    log_in_as(user)
    visit question_path(question)

    fill_in 'Ответ', with: "Why do you need this, anyway?"
    attach_file 'answer_attachments_file', "#{Rails.root}/spec/spec_helper.rb"
    click_button 'Отправить'

    within '#answers-block' do
      # Так как тесты должны не зависеть друг от друга, то применяем regexp:
      link = page.find('a', text: 'spec_helper.rb')
      expect(link[:href]).to match %r!/uploads/attachment/file/*./spec_helper.rb!
    end
  end
end
