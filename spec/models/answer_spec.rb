require 'rails_helper'

RSpec.describe Answer, type: :model do
  let (:user) { create(:user) }
  let (:other_user) { create(:user_multi) }
  let (:question) { create(:question, user: user) }
  let (:answer) { create(:answer, user: user, question: question) }

  context "with validations" do
    it { should validate_presence_of :question_id }

    it { should validate_presence_of :body }
    it { should validate_length_of(:body).is_at_least(10).is_at_most 10.kilobytes }

    it { should belong_to(:question) }
    it { should belong_to(:user) }

    it { should have_many(:attachments) }
    it { should have_many(:votes) }
  end

  it "has default best status" do
    expect(answer).not_to be_best
  end

  it "can switch best status to true" do
    answer.switch_promotion!
    expect(answer).to be_best
  end 

  it "can switch best status to false" do
    answer.best = true
    answer.switch_promotion!
    expect(answer).not_to be_best
  end 

  it "can toggle best status between many answers" do
    other = create(:answer_multi, question: question)
    other.switch_promotion!
    answer.switch_promotion!
    expect(other.reload).not_to be_best
  end

  it "has default zero score" do
    expect(answer.score).to eq 0
  end

  it "can upvote score" do
    expect {
      answer.vote(:up, other_user.id)
    }.to change(answer, :score).by 1
  end

  it "can downvote score" do
    expect {
      answer.vote(:down, other_user.id)
    }.to change(answer, :score).by -1
  end

  it "creates votes on voting" do
    expect {
      answer.vote(:down, other_user.id)
    }.to change(answer.votes, :count).by 1    
  end

  it "cannot make votes when voter is creator" do
    expect {
      answer.vote(:down, user.id)
    }.not_to change(answer, :score)
  end

  it "cannot make same votes twice when same user" do
    answer.vote(:down, other_user.id)
    expect {
      answer.vote(:down, other_user.id)
    }.not_to change(answer, :score)
  end

  it "can make different votes twice when same user" do
    answer.vote(:down, other_user.id)
    expect {
      answer.vote(:up, other_user.id)
    }.to change(answer, :score).by 1
  end

  it "destroys votes on making different votes twice when same user" do
    answer.vote(:up, other_user.id)
    expect {
      answer.vote(:down, other_user.id)
    }.to change(answer.votes, :count).by -1    
  end

  it "returns true when making correct vote" do
    expect(answer.vote(:up, other_user.id)).to eq true
  end

  it "returns true when correctly destroying vote" do
    answer.vote(:down, other_user.id)
    expect(answer.vote(:up, other_user.id)).to eq true
  end

  it "returns false when creator is voter" do
    expect(answer.vote(:up, user.id)).to eq false
  end

  it "returns false when doubling same vote" do
    answer.vote(:up, user.id)
    expect(answer.vote(:up, user.id)).to eq false
  end
end
