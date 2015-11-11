require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let (:question) { create(:question) }
  let (:answer) { create(:answer, question: question) }

  describe 'GET #index' do
    let (:answers) { create_list(:answer, 2, question: question) }

    before { get :index, question_id: question }

    it 'populates an array of all answers' do
      expect(assigns(:answers)).to match_array(answers)
    end

    it 'renders the :index template' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before(:each) { get :show, id: answer, question_id: question }

    it "assigns the requested answer to @answer" do     
      expect(assigns(:answer)).to eq answer
    end

    it "renders the :show template" do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before(:each) { get :new, question_id: question }
    
    it "assigns a new Answer to @answer" do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    # Не уверен, стоит ли дергать базу?..
    it "adds @question to @answer parents" do
      expect(assigns(:answer).question).to eq question
    end

    it "renders the :new template" do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it "saves the new answer to database" do
        question
        expect {
          post :create, answer: attributes_for(:answer), question_id: question
        }.to change(Answer, :count).by 1
      end

      it "redirects to answers path" do
        post :create, answer: attributes_for(:answer), question_id: question
        expect(response).to redirect_to question_answers_path(question)
      end
    end

    context 'with invalid attributes' do
      it "saves the new answer to database" do
        question
        expect {
          post :create, answer: attributes_for(:answer_invalid), question_id: question
        }.not_to change(Answer, :count)
      end

      it "re-renders the :new template" do
        post :create, answer: attributes_for(:answer_invalid), question_id: question
        expect(response).to render_template :new
      end 

      it "shows error message" do
        post :create, answer: attributes_for(:answer_invalid), question_id: question
        expect(assigns(:answer).errors).not_to be_empty
      end  
    end
  end
end
