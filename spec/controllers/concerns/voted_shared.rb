require 'rails_helper'

shared_examples_for "voted" do
  let (:user) { create(:user) }
  let (:votable) { create(described_class.model_klass.to_s.underscore.to_sym, user: user) }

  describe 'PATCH #vote' do  
    shared_examples_for 'not voting for votable' do
      it 'does not raise score' do
        patch_vote(votable, :up)
        expect {
          votable.reload
        }.not_to change(votable, :score)
      end    

      it 'does not lower score' do
        patch_vote(votable, :down)
        expect {
          votable.reload
        }.not_to change(votable, :score)
      end   
    end

    describe 'when logged in' do
      context 'as correct user' do
        let (:other) { create(:user_multi) }
        before(:each) { log_in_as other }

        it "assigns correct Votable to @votable" do
          patch_vote(votable, :down)
          expect(assigns(:votable)).to eq votable
        end

        it "renders the JSON score value" do
          patch_vote(votable, :down)
          parsed_body = JSON.parse(response.body)
          expect(parsed_body["score"]).to eq votable.reload.score
        end   

        it "increments score for @votable" do
          patch_vote(votable, :up)
          expect {
            votable.reload
          }.to change(votable, :score).by 1
        end    

        it "decrements score for @votable" do
          patch_vote(votable, :down)
          expect {
            votable.reload
          }.to change(votable, :score).by -1
        end    
      end

      context 'as incorrect user' do
        before(:each) { log_in_as user }

        it_behaves_like 'not voting for votable'
      end
    end

    context 'when logged out' do
      it_behaves_like 'not voting for votable'
    end    
  end    
end
