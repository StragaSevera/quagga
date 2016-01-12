class Authorization < ActiveRecord::Base
  belongs_to :user, required: true

  validates :provider, presence: true
  validates :uid, presence: true
end
