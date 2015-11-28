require 'rails_helper'

RSpec.describe Answer, type: :model do
  let (:answer) { build(:answer) }

  context "with validations" do
    it { should validate_presence_of :question_id }

    it { should validate_presence_of :body }
    it { should validate_length_of(:body).is_at_least(10).is_at_most 10.kilobytes }

    it { should belong_to(:question) }
    it { should belong_to(:user) }
  end

  it "can be promotable" do
    answer.promote!
    expect(answer.question.best_answer).to eq answer
  end

  it "can check promoted status" do
    expect {
      answer.promote!
    }.to change(answer, :best?).from(false).to(true)
  end

  it "can be demotable" do
    answer.promote!
    answer.demote!
    expect(answer.question.best_answer).to eq nil
  end

  # Ну не разбивать же на две спеки?..
  it "can switch best status" do
    answer.switch_promotion!
    expect(answer).to be_best
    answer.switch_promotion!
    expect(answer).not_to be_best
  end 
end
