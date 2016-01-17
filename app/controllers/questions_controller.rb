class QuestionsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]
  
  before_action :load_question, only: [:show, :update, :destroy]
  before_action :load_answers, only: [:show]

  authorize_resource

  after_action :publish_question, only: [:create]

  respond_to :js, only: :update

  include Voted

  def index
    respond_with @questions = Question.accessible_by(current_ability).page(params[:page]).order('id DESC')
  end

  def show
    respond_with @question
  end

  def new
    respond_with @question = current_user.questions.build
  end

  def create
    respond_with @question = current_user.questions.create(question_params)
  end

  def update
    @question.update(question_params)
    respond_with @question
  end

  def destroy
    respond_with @question.destroy
  end

  private
    def load_question
      @question = Question.find(params[:id])
    end

    def load_answers
      @answers = @question.answers.accessible_by(current_ability).page(params[:page])
    end

    def publish_question
      PrivatePub.publish_to "/questions", render_to_string(partial: "questions/publish.js.erb") if @question.errors.empty?
    end

    def question_params
      params.require(:question).permit(:title, :body, attachments_attributes: [:file])
    end
end
