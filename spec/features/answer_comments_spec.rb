require 'feature_helper'

RSpec.feature "AnswerComments", 
  %q{
    In order to troll answer
    As an user
    I want to comment answer
  },
  type: :feature do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, user: user, question: question) }

  it_behaves_like "commented as user", "answer", "#answers-block" do
    background(:each) do
      log_in_as(user)
      @id = answer.id
      visit question_path(question)
    end
  end

  it_behaves_like "commented as guest", "answer", "#answers-block" do
    background(:each) do
      @id = answer.id
      visit question_path(question)
    end
  end
end