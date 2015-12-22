require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let (:user) { create(:user) }
  let (:question) { create(:question, user: user) }
  let! (:answer) { create(:answer, user: user, question: question) }
  let (:comment) { create(:comment, user:user, commentable: question) }

  describe 'POST #create' do
    context 'when logged in' do
      before(:each) { log_in_as user }

      context 'with valid attributes' do
        it "can add @comment to question" do
          expect {
            post :create, comment: attributes_for(:comment, commentable_id: question.id, commentable_type: "Question"), format: :js
          }.to change(question.comments, :count).by 1
        end

        it "can add @comment to answer" do
          expect {
            post :create, comment: attributes_for(:comment, commentable_id: answer.id, commentable_type: "Answer"), format: :js
          }.to change(answer.comments, :count).by 1
        end

        it "adds @user to @comment parents" do
          expect {
            post :create, comment: attributes_for(:comment, commentable_id: answer.id, commentable_type: "Answer"), format: :js
          }.to change(user.comments, :count).by 1
        end

        it "renders js :create" do
          post :create, comment: attributes_for(:comment, commentable_id: answer.id, commentable_type: "Answer"), format: :js
          expect(response).to render_template :create
        end
      end

      context 'with invalid attributes' do
        it "does not save the new comment to database" do
          expect {
            post :create, comment: attributes_for(:comment_invalid, commentable_id: answer.id, commentable_type: "Answer"), format: :js
          }.not_to change(Comment, :count)
        end

        it "renders js :create" do
          post :create, comment: attributes_for(:comment_invalid, commentable_id: answer.id, commentable_type: "Answer"), format: :js
          expect(response).to render_template :create
        end

        it "shows error message" do
          post :create, comment: attributes_for(:comment_invalid, commentable_id: answer.id, commentable_type: "Answer"), format: :js
          expect(assigns(:comment).errors).not_to be_empty
        end  
      end
    end

    context 'when logged out' do
      it "does not save the new comment to database" do
        expect {
          post :create, comment: attributes_for(:comment_invalid, commentable_id: answer.id, commentable_type: "Answer"), format: :js
        }.not_to change(Comment, :count)
      end   
    end
  end
end
