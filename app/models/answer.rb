class Answer < ActiveRecord::Base
  has_many :attachments, as: :attachable
  has_many :votes, as: :votable

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

  def vote(direction, user_id)
    return false if self.user_id == user_id
    case direction.to_s
    when "up"
      score = 1
    when "down"
      score = -1
    end
    vote = votes.where(user_id: user_id).first
    if vote
      if vote.score == -score
        transaction do
          self.score += score
          vote.destroy 
          save!
        end
      else
        return false
      end
    else
      transaction do
        self.score += score
        votes.create(user_id: user_id, score: score)
        save!
      end
    end
  end
end
