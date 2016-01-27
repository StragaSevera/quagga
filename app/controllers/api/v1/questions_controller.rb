class Api::V1::QuestionsController < Api::V1::BaseController
  def index
    authorize! :index, Question
    @questions = Question.all
    respond_with @questions
  end
end