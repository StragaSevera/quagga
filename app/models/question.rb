class Question < ActiveRecord::Base
  has_many :answers, dependent: :destroy
  belongs_to :user, required: true

  validates :title, presence: true, length: { in: 5..150 }
  validates :body, presence: true, length: { in: 10..10.kilobytes }

  def promote!(answer)
    self.demote!
    answer.best = true
    answer.save!
  end

  # В теории, это должно быть быстрее, чем итерация через
  # each или аналоги. Не уверен, корректно ли это идеоматически...
  # Альтернатива:
  # def demote!
  #   self.answers.each do |answer|
  #     answer.best = false
  #     answer.save!
  #   end
  # end
  # 
  # def best_answer
  #   self.answers.find do |answer|
  #     answer.best?
  #   end
  # end  
  # Плюс этого варианта - не нужны многочисленные reload в тестах и аяксе.
  # Минус - должно тормозить сильнее, чем SQL-запрос.

  def demote!
    self.answers.update_all(best: false)
  end

  def best_answer
    self.answers.where(best: true).limit(1).first
  end

  def switch_promotion!(answer)
    if answer.best?
      self.demote!
    else
      self.promote!(answer)
    end
  end
end
