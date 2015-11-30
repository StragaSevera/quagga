class Answer < ActiveRecord::Base
  belongs_to :question, required: true
  belongs_to :user, required: true

  validates :question_id, presence: true 
  validates :body, presence: true, length: { in: 10..10.kilobytes }

  self.per_page = 10

  def promote!
    self.question.promote!(self)
  end

  def demote!
    self.question.demote!
  end

  def switch_promotion!
    self.question.switch_promotion!(self)
  end
end
