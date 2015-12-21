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

  it_behaves_like "commented as user", "question" do
    background(:each) do
      log_in_as(user)
      visit question_path(question)
    end
  end

  it_behaves_like "commented as guest", "question" do
    background(:each) do
      visit question_path(question)
    end
  end
end