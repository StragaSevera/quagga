class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :name, presence: true, length: { in: 2..30 }
  validates :email, presence: true, length: { in: 2..200 }
  validates :password, presence: true, length: { in: 4..200 }
end
