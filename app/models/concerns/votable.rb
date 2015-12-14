module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable
    validates :score, presence: true 
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
    transaction do
      if vote
        return false if vote.score == score
        vote.destroy
      else
        votes.create(user_id: user_id, score: score)
      end
      self.score += score
      save!
    end
  end  
end