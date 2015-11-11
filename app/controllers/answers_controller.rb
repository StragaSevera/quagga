class AnswersController < ApplicationController
  before_action :load_question
  before_action :load_answer, only: [:show, :edit]

  def index
    @answers = @question.answers.page(params[:page]).order('id DESC')
  end

  def show
  end

  def new
    # Не уверен, может быть, не дергать базу
    # и сделать просто @answer = Answer.new ?
    @answer = @question.answers.new
  end

  def create
    @answer = @question.answers.new(answer_params)
    if @answer.save
      redirect_to question_answers_path(@question)
    else
      render :new
    end
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
end
