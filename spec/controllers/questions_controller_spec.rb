require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 2) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end    
  end

  describe 'GET #show' do
    before(:each) { get :show, id: question }

    it "assigns the requested question to @question" do     
      expect(assigns(:question)).to eq question
    end

    it "renders the :show template" do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before(:each) { get :new }
    
    it "assigns a new Question to @question" do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it "renders the :new template" do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it "saves the new question to database" do
        expect {
          post :create, question: attributes_for(:question)
        }.to change(Question, :count).by 1
      end

      it "redirects to questions path" do
        post :create, question: attributes_for(:question)
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      it "saves the new question to database" do
        expect {
          post :create, question: attributes_for(:question_invalid)
        }.not_to change(Question, :count)
      end

      it "re-renders the :new template" do
        post :create, question: attributes_for(:question_invalid)
        expect(response).to render_template :new
      end 

      it "shows error message" do
        post :create, question: attributes_for(:question_invalid)
        expect(assigns(:question).errors).not_to be_empty
      end  
    end
  end
end
