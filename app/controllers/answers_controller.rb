class AnswersController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show]

  before_action :load_question
  before_action :load_answer, only: [:show, :update, :destroy, :switch_promotion]

  authorize_resource

  respond_to :js

  include Voted

  def show
    respond_with @answer
  end

  def create
    respond_with @answer = @question.answers.create(answer_params.merge({user_id: current_user.id}))
  end

  def update
    @answer.update(answer_params.merge({user_id: current_user.id}))
    respond_with @answer
  end

  def destroy
    respond_with @answer.destroy
  end

  def switch_promotion
    @answer.switch_promotion!
    respond_with @answer
  end

  private
    def load_question
      @question = Question.find(params[:question_id])
    end

    def load_answer
      @answer = @question.answers.find(params[:id])
    end

    def answer_params
      params.require(:answer).permit(:body, attachments_attributes: [:file])
    end
end
