require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let (:user) { create(:user) }
  let (:attachable) { create(:question) }
  let! (:attachment) { create(:attachment, attachable: attachable) }

  describe 'DELETE #destroy' do
    shared_examples_for 'not deleting attachment' do
      it "does not delete answer" do
        expect {
          delete :destroy, id: attachment, format: :js
        }.not_to change(Attachment, :count)
      end 
    end

    context 'when logged in' do
      context 'as correct user' do
        before(:each) { log_in_as user }

        it 'deletes the attachment' do
          expect {
            delete :destroy, id: attachment, format: :js
          }.to change(Attachment, :count).by -1
        end 

        it "renders the :destroy template"  do
          delete :destroy, id: attachment, format: :js
          expect(response).to render_template :destroy
        end
      end

      context 'as incorrect user' do
        let (:other) { create(:user_multi) }
        before(:each) { log_in_as other }

        it_behaves_like 'not deleting attachment'
      end
    end

    context 'when logged out' do
      it_behaves_like 'not deleting attachment'
    end
  end
end
