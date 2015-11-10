require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question) }

  describe 'GET #show' do
    before(:each) { get :show, id: question }

    it "assigns the requested question to @question" do     
      expect(assigns(:question)).to eq question
    end

    it "renders the :show template" do
      expect(response).to render_template :show
    end
  end

  xdescribe 'GET #new' do
    before(:each) { get :new }
    it "assigns a new Question to @question" do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it "renders the :new template" do
      expect(response).to render_template :new
    end
  end

  xdescribe 'POST #create' do
    context 'with valid attributes' do
      it "saves the new question to database" do
        expect {
          question :create, question: attributes_for(:question)
        }.to change(Question, :count).by 1
      end

      it "redirects to questions path" do
        question :create, question: attributes_for(:question)
        expect(response).to redirect_to questions_path
      end 
    end

    context 'with invalid attributes' do
      it "saves the new question to database" do
        expect {
          question :create, question: attributes_for(:question_invalid)
        }.not_to change(Question, :count)
      end

      it "re-renders the :new template" do
        question :create, question: attributes_for(:question_invalid)
        expect(response).to render_template :new
      end 

      it "shows error message" do
        question :create, question: attributes_for(:question_invalid)
        expect(assigns(:question).errors).not_to be_empty
      end  
    end
  end
end
