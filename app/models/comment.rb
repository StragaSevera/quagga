class Comment < ActiveRecord::Base
  belongs_to :user, required: true
  belongs_to :commentable, polymorphic: true

  def question_id
    case commentable_type
    when "Question"
      commentable.id
    when "Answer"
      commentable.question_id
    end
  end

  validates :body, presence: true, length: { in: 5..1.kilobyte }
end
