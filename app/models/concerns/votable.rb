module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable
    validates :score, presence: true 
  end

  POINTS = {up: 1, down: -1}
  def vote(direction, user_id)
    return false if self.user_id == user_id

    points = POINTS[direction.to_sym]

    vote = votes.where(user_id: user_id).first
    transaction do
      if vote
        return false if vote.score == points
        vote.destroy!
      else
        votes.create!(user_id: user_id, score: points)
      end
      self.score += points
      save!
    end
  end
end