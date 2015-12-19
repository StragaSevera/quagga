require 'feature_helper'

RSpec.feature "QuestionVote", 
  %q{
    In order to promote question
    As an user
    I want to vote for question
  },
  type: :feature do

  given(:user) { create(:user) }
  given(:other) { create(:user_multi) }
  given!(:question) { create(:question, user: user) }

  it_behaves_like "voted as correct user", "questions" do
    background(:each) do
      log_in_as(other)
      visit questions_path
    end
  end

  it_behaves_like "voted as incorrect user", "questions" do
    background(:each) do
      log_in_as(user)
      visit questions_path
    end
  end
end
