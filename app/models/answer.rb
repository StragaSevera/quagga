class Answer < ActiveRecord::Base
  belongs_to :question, required: true
  belongs_to :user, required: true

  validates :question_id, presence: true 
  validates :body, presence: true, length: { in: 10..10.kilobytes }

  self.per_page = 10

  def switch_promotion!
    if self.valid?
      if self.best?
        self.best = false
      else
        # Стоит ли делать через SQL, или лучше через each?
        self.question.answers.update_all(best: false)
        self.best = true
      end
      self.save
    end
  end
end
