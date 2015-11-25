require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 2, user: user) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders the :index template' do
      expect(response).to render_template :index
    end    
  end

  describe 'GET #show' do
    let (:answers) { create_list(:answer, 2, user: user, question: question) }
    before(:each) { get :show, id: question }


    it "assigns the requested question to @question" do     
      expect(assigns(:question)).to eq question
    end

    it "renders the :show template" do
      expect(response).to render_template :show
    end

    it 'populates an array of all answers' do
      expect(assigns(:answers)).to match_array(answers)
    end
  end

  describe 'GET #new' do
    context 'when logged in' do
      before(:each) { log_in_as user }
      before(:each) { get :new }
    
      it "assigns a new Question to @question" do
        expect(assigns(:question)).to be_a_new(Question)
      end

      it "has parent user for @question" do
        expect(assigns(:question).user).to eq user
      end

      it "renders the :new template" do
        expect(response).to render_template :new
      end
    end

    context 'when logged out' do
      # Нет, мы не тестируем здесь чужой код.
      # Мы проверяем, не удалил ли кто-то случайно строчку из кода нашего ;-)
      it "does not assign a new Question to @question" do
        expect(assigns(:question)).to be_nil
      end    
    end
  end

  describe 'POST #create' do
    context 'when logged in' do
      before(:each) { log_in_as user }
    
      context 'with valid attributes' do
        it "has parent user for @question" do
          expect {
            post :create, question: attributes_for(:question)
          }.to change(user.questions, :count).by 1
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

    context 'when logged out' do
      it "does not assign a new Question to @question" do
        expect {
          post :create, question: attributes_for(:question_invalid)
        }.not_to change(Question, :count)
      end
    end
  end

  describe 'DELETE #destroy' do
    let! (:question) { create(:question, user: user) }

    context 'when logged in' do
      context 'as correct user' do
        before(:each) { log_in_as user }

        it 'deletes the question' do
          expect {
            delete :destroy, id: question
          }.to change(Question, :count).by -1
        end

        it "redirects to question#index" do
          delete :destroy, id: question
          expect(response).to redirect_to questions_path
        end
      end

      context 'as incorrect user' do
        let (:other) { create(:user_multi) }
        before(:each) { log_in_as other }

        it "does not delete question" do
          expect {
            delete :destroy, id: question
          }.not_to change(Question, :count)
        end 
      end
    end

    context 'when logged out' do
      it "does not delete question" do
        expect {
          delete :destroy, id: question
        }.not_to change(Question, :count)
      end      
    end
  end
end
