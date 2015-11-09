class Answer < ActiveRecord::Base
  belongs_to :question, required: true

  validates :question_id, presence: true 
  validates :body, presence: true, length: { in: 10..10.kilobytes }
end
