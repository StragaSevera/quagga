require 'feature_helper'

RSpec.feature "AnswerVote", 
  %q{
    In order to promote answer
    As an user
    I want to vote for answer
  },
  type: :feature do

  given(:user) { create(:user) }
  given(:other) { create(:user_multi) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  it_behaves_like "voted as correct user", "answers" do
    background(:each) do
      log_in_as(other)
      visit question_path(question)
    end
  end

  context "voting as same user" do
    it_behaves_like "voted as incorrect user", "answers" do
      background(:each) do
        log_in_as(user)
        visit question_path(question)
      end
    end
  end

  context "voting as no user" do
    it_behaves_like "voted as incorrect user", "answers" do
      background(:each) do
        visit question_path(question)
      end
    end
  end
end
