class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]
  before_action :load_question
  before_action :load_answer, only: [:show, :destroy]
  before_action :check_current_user, only: [:destroy]

  def show
  end

  def create
    @answer = @question.answers.build(answer_params)
    @answer.user = current_user
    if @answer.save
      redirect_to question_path(@question)
    else
      @answers = @question.answers.page(params[:page]).order('id DESC')
      render "questions/show"
    end
  end

  def destroy
    @answer.destroy
    flash[:success] = "Ответ был удален!"

    redirect_to question_url(@question)
  end

  private
    def load_question
      @question = Question.find(params[:question_id])
    end

    def load_answer
      @answer = @question.answers.find(params[:id])
    end

    def answer_params
      params.require(:answer).permit(:body)
    end  

    def check_current_user
      redirect_to root_url unless @answer.user == current_user
    end
end
