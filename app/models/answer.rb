class Answer < ActiveRecord::Base
  include Votable
  include Attachable
  include Commentable

  belongs_to :question, required: true
  belongs_to :user, required: true

  validates :question_id, presence: true 
  validates :body, presence: true, length: { in: 10..10.kilobytes }

  after_save :send_email_to_subscribers

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

  protected # не private, дабы можно было переопределить в eigenclass
    def send_email_to_subscribers
      QuestionSubscribersJob.perform_later(question, self)
    end
end
