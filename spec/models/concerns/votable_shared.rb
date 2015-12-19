require 'rails_helper'

shared_examples_for "votable" do
  let (:votable) { create(described_class.to_s.underscore.to_sym) }
  let (:same_user_id) { votable.user_id }
  let (:other_user_id) { create(:user_multi).id }

  it { should have_many(:votes) } 
  it { should validate_presence_of :score } 

  it "can upvote score" do
    expect {
      votable.vote(:up, other_user_id)
    }.to change(votable, :score).by 1
  end

  it "can downvote score" do
    expect {
      votable.vote(:down, other_user_id)
    }.to change(votable, :score).by -1
  end

  it "creates votes on voting" do
    expect {
      votable.vote(:down, other_user_id)
    }.to change(votable.votes, :count).by 1    
  end

  it "cannot make votes when voter is creator" do
    expect {
      votable.vote(:down, same_user_id)
    }.not_to change(votable, :score)
  end

  it "cannot make same votes twice when same user" do
    votable.vote(:down, other_user_id)
    expect {
      votable.vote(:down, other_user_id)
    }.not_to change(votable, :score)
  end

  it "can make different votes twice when same user" do
    votable.vote(:down, other_user_id)
    expect {
      votable.vote(:up, other_user_id)
    }.to change(votable, :score).by 1
  end

  it "destroys votes on making different votes twice when same user" do
    votable.vote(:up, other_user_id)
    expect {
      votable.vote(:down, other_user_id)
    }.to change(votable.votes, :count).by -1    
  end

  it "returns true when making correct vote" do
    expect(votable.vote(:up, other_user_id)).to eq true
  end

  it "returns true when correctly destroying vote" do
    votable.vote(:down, other_user_id)
    expect(votable.vote(:up, other_user_id)).to eq true
  end

  it "returns false when creator is voter" do
    expect(votable.vote(:up, same_user_id)).to eq false
  end

  it "returns false when doubling same vote" do
    votable.vote(:up, other_user_id)
    expect(votable.vote(:up, other_user_id)).to eq false
  end
end