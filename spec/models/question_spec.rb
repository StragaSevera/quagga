require 'rails_helper'

RSpec.describe Question, type: :model do
  let (:question) { create(:question) }

  context "with validations" do
    it { should validate_presence_of :title }
    it { should validate_length_of(:title).is_at_least(5).is_at_most 150 }

    it { should validate_presence_of :body }
    it { should validate_length_of(:body).is_at_least(10).is_at_most 10.kilobytes }

    it { should have_many(:answers).dependent(:destroy) } 
    it { should belong_to(:user) }
  end

  it "can promote answers" do
    answer = create(:answer, question: question)
    question.promote!(answer)
    expect(question.best_answer).to eq answer
  end

  it "can demote answers" do
    answer = create(:answer, question: question)
    question.promote!(answer)
    question.demote!
    expect(question.best_answer).to eq nil
  end   

  # Ну не разбивать же на две спеки?..
  it "can switch best status" do
    answer = create(:answer, question: question)
    question.switch_promotion!(answer)
    expect(question.best_answer).to eq answer
    question.switch_promotion!(answer)
    expect(question.best_answer).to eq nil
  end  
end
