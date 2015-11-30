class Question < ActiveRecord::Base
  has_many :answers, dependent: :destroy
  belongs_to :user, required: true

  validates :title, presence: true, length: { in: 5..150 }
  validates :body, presence: true, length: { in: 10..10.kilobytes }

  def best_answer
    self.answers.where(best: true).limit(1).first
  end
end
