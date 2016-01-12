class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :omniauthable, omniauth_providers: [:facebook]
  devise :validatable, password_length: 4..200

  # Зависимость не ставим, ибо информация должна храниться вечно! ;-)
  has_many :questions
  has_many :answers
  has_many :comments

  validates :name, presence: true, length: { in: 2..30 }
  validates :email, length: { in: 2..200 }
end
