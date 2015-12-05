class Answer < ActiveRecord::Base
  has_many :attachments, as: :attachable
  
  belongs_to :question, required: true
  belongs_to :user, required: true

  validates :question_id, presence: true 
  validates :body, presence: true, length: { in: 10..10.kilobytes }

  self.per_page = 10

  def switch_promotion!
    self.transaction do
      if self.valid?
        if self.best?
          self.best = false
        else
          self.question.answers.update_all(best: false)
          self.best = true
        end
        self.save
      end
    end
  end
end
