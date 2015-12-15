class QuestionsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]
  before_action :load_question, only: [:show, :update, :destroy]
  before_action :check_current_user, only: [:update, :destroy]

  include Voted

  def index
    @questions = Question.page(params[:page]).order('id DESC')    
  end

  def show
    if @question.best_answer
      @best_answer = @question.best_answer
      @answers = @question.answers.where.not(id: @best_answer.id).page(params[:page]).order('id DESC')
    else
      @answers = @question.answers.page(params[:page]).order('id DESC')
    end

    @answer = @question.answers.build
    @answer.attachments.build
  end

  def new
    @question = current_user.questions.build
    @question.attachments.build
  end

  def create
    @question = current_user.questions.build(question_params)
    if @question.save
      redirect_to @question
    else
      render :new
    end
  end

  def update
    if @question.update_attributes(question_params)
      flash.now[:success] = "Вопрос был изменен!"
    end
  end

  def destroy
    @question.destroy
    flash[:success] = "Вопрос был удален!"

    redirect_to questions_url
  end

  private
    def load_question
      @question = Question.find(params[:id])
    end

    def question_params
      params.require(:question).permit(:title, :body, attachments_attributes: [:file])
    end

    def check_current_user
      redirect_to root_url unless current_user && @question.user.id == current_user.id
    end
end
