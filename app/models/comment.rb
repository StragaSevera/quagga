class Comment < ActiveRecord::Base
  belongs_to :user, required: true
  belongs_to :commentable, polymorphic: true

  validates :body, presence: true, length: { in: 5..1.kilobyte }

  def question_id
    commentable.try(:question_id) || commentable.id
  end
end
