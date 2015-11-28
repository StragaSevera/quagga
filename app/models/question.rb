class Question < ActiveRecord::Base
  has_many :answers, dependent: :destroy
  belongs_to :best_answer, class_name: :Answer, foreign_key: 'best_answer_id'
  belongs_to :user, required: true

  validates :title, presence: true, length: { in: 5..150 }
  validates :body, presence: true, length: { in: 10..10.kilobytes }

  def promote!(answer)
    self.best_answer = answer
    self.save
  end

  def demote!
    self.best_answer = nil
    self.save
  end

  def switch_promotion!(answer)
    if self.best_answer == answer
      self.demote!
    else
      self.promote!(answer)
    end
  end
end
