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

  # В случае, если бы я решил не кешировать голоса
  # полем в модели, код выглядел бы примерно так.
  # В контроллере question была бы дополнительная оптимизация
  # при помощи left join (чтобы не дергать базу на каждом ответе).
  # Вариант протестирован и сбоев во спеках не вызывает (кроме отсутствия валидации поля за неимением этого поля).

  # def score
  #   votes.sum(:score)
  # end

  # def vote(direction, user_id)
  #   return false if self.user_id == user_id

  #   case direction.to_s
  #   when "up"
  #     points = 1
  #   when "down"
  #     points = -1
  #   end

  #   vote = votes.where(user_id: user_id).first
  #   transaction do
  #     if vote
  #       return false if vote.score == points
  #       vote.destroy
  #     else
  #       votes.create(user_id: user_id, score: points)
  #     end
  #   end
  # end  
end