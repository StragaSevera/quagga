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
    it { should have_one(:best_answer).conditions(best: true).class_name(:Answer) } 

    it { should have_many(:attachments) } 
    it { should accept_nested_attributes_for :attachments }
  end

  it "can get best answer" do
    answer = create(:answer, question: question)
    answer.switch_promotion!
    expect(question.best_answer).to eq answer
  end
end