require 'feature_helper'

RSpec.feature "QuestionComments", 
  %q{
    In order to pinpoint question
    As an user
    I want to comment question
  },
  type: :feature do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  it_behaves_like "commented as user", "question", "#question-block" do
    background(:each) do
      log_in_as(user)
      @id = question.id
      visit question_path(question)
    end
  end

  it_behaves_like "commented as guest", "question", "#question-block" do
    background(:each) do
      @id = question.id
      visit question_path(question)
    end
  end
end