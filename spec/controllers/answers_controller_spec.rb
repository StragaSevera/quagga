require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let (:user) { create(:user) }
  let (:question) { create(:question, user: user) }
  let (:answer) { create(:answer, user: user, question: question) }

  describe 'GET #show' do
    before(:each) { get :show, id: answer, question_id: question }

    it "assigns the requested answer to @answer" do     
      expect(assigns(:answer)).to eq answer
    end

    it "renders the :show template" do
      expect(response).to render_template :show
    end
  end

  describe 'POST #create' do
    context 'when logged in' do
      before(:each) { log_in_as user }

      context 'with valid attributes' do
        it "adds @question to @answer parents" do
          expect {
            post :create, answer: attributes_for(:answer), question_id: question
          }.to change(question.answers, :count).by 1
        end

        it "adds @user to @answer parents" do
          expect {
            post :create, answer: attributes_for(:answer), question_id: question
          }.to change(user.answers, :count).by 1
        end

        it "redirects to question path" do
          post :create, answer: attributes_for(:answer), question_id: question
          expect(response).to redirect_to question_path(question)
        end
      end

      context 'with invalid attributes' do
        it "does not save the new answer to database" do
          question
          expect {
            post :create, answer: attributes_for(:answer_invalid), question_id: question
          }.not_to change(Answer, :count)
        end

        it "redirects to question path" do
          post :create, answer: attributes_for(:answer_invalid), question_id: question
          expect(response).to render_template 'questions/show'
        end

        it "shows error message" do
          post :create, answer: attributes_for(:answer_invalid), question_id: question
          expect(assigns(:answer).errors).not_to be_empty
        end  
      end
    end

    context 'when logged out' do
      it "does not save the new answer to database" do
        question
        expect {
          post :create, answer: attributes_for(:answer_invalid), question_id: question
        }.not_to change(Answer, :count)
      end   
    end
  end

  describe 'DELETE #destroy' do
    context 'when logged in' do
      context 'as correct user' do
        before(:each) { log_in_as user }

        it 'deletes the question' do
          answer
          expect {
            delete :destroy, id: answer.id, question_id: question.id
          }.to change(Answer, :count).by -1
        end

        it "redirects to question#index" do
          delete :destroy, id: answer.id, question_id: question.id
          expect(response).to redirect_to question_path(question)
        end
      end

      context 'as incorrect user' do
        let (:other) { create(:user_multi) }
        before(:each) { log_in_as other }

        it "does not delete question" do
          answer
          expect {
            delete :destroy, id: answer.id, question_id: question.id
          }.not_to change(Answer, :count)
        end 
      end
    end

    context 'when logged out' do
      it "does not delete question" do
        answer
        expect {
          delete :destroy, id: answer.id, question_id: question.id
        }.not_to change(Answer, :count)
      end      
    end
  end
end
