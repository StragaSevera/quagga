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
    respond_to do |format|
      if @result = @answer.save
        format.html { redirect_to question_path(@question) }
        format.js
      else
        format.html do 
          @answers = @question.answers.page(1).order('id DESC')
          render "questions/show" 
        end

        format.js
      end
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
