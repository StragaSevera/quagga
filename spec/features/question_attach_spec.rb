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

  scenario 'User adds file when asks question' do
    visit new_question_path

    fill_in 'Заголовок', with: 'Rails autoloading'
    fill_in 'Вопрос', with: "How can I autoload a class defined in module?\nPlease, help!"
    attach_file 'Файл', "#{Rails.root}/spec/spec_helper.rb"
    click_button 'Задать вопрос'

    within '#question-block' do
      # Так как тесты должны не зависеть друг от друга, то применяем regexp:
      link = page.find('a', text: 'spec_helper.rb')
      expect(link[:href]).to match %r!/uploads/attachment/file/*./spec_helper.rb!
    end
  end
end
