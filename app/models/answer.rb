class Answer < ActiveRecord::Base
  include Votable
  include Attachable

  belongs_to :question, required: true
  belongs_to :user, required: true

  validates :question_id, presence: true 
  validates :body, presence: true, length: { in: 10..10.kilobytes }

  self.per_page = 10

  def switch_promotion!
    transaction do
      if best?
        self.best = false
      else
        question.answers.update_all(best: false)
        self.best = true
      end
      save!
    end
  end
end
