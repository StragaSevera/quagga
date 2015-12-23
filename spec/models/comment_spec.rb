require 'rails_helper'

RSpec.describe Comment, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:commentable) }
  it { should validate_presence_of :body }
  it { should validate_length_of(:body).is_at_least(5).is_at_most 1.kilobyte }

  it "handles question_id when belongs to Question" do
    question = create(:question)
    comment = create(:comment, commentable: question)
    expect(comment.question_id).to eq question.id
  end

  it "handles question_id when belongs to Answer" do
    answer = create(:answer)
    comment = create(:comment, commentable: answer)
    expect(comment.question_id).to eq answer.question_id
  end
end
