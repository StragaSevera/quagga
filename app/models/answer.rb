class Answer < ActiveRecord::Base
  has_many :attachments, as: :attachable

  belongs_to :question, required: true
  belongs_to :user, required: true

  validates :question_id, presence: true 
  validates :body, presence: true, length: { in: 10..10.kilobytes }

  accepts_nested_attributes_for :attachments, reject_if: :all_blank

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

  def vote(direction)
    case direction.to_s
    when "up"
      self.score += 1
    when "down"
      self.score -= 1
    end
    save!
  end
end
