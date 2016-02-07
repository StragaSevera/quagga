class Question < ActiveRecord::Base
  include Votable
  include Attachable
  include Commentable

  has_many :answers, -> { order('best DESC, id DESC') }, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  
  has_one :best_answer, -> { where(best: true) }, class_name: 'Answer'

  scope :digest, -> { where("created_at >= ?", 1.day.ago) }
  
  belongs_to :user, required: true

  validates :title, presence: true, length: { in: 5..150 }
  validates :body, presence: true, length: { in: 10..10.kilobytes }

  after_create :subscribe_user

  private 
    def subscribe_user
      self.user.subscribe_to(self)
    end
end
