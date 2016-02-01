class Api::V1::AnswersController < Api::V1::BaseController
  before_action :load_question
  authorize_resource

  def index
    @answers = @question.answers.all
    respond_with @answers
  end

  def show
    @answer = @question.answers.find(params[:id])
    respond_with @answer, serializer: AnswerShowSerializer
  end

  def create
  end

  private
    def load_question
      @question = Question.find(params[:question_id])
    end
end