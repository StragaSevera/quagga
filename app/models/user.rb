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
  has_many :authorizations

  validates :name, presence: true, length: { in: 2..30 }
  validates :email, length: { in: 2..200 }

  class << self
    def find_for_oauth(auth_hash)
      authorization = Authorization.where(provider: auth_hash.provider, uid: auth_hash.uid.to_s).first
      return authorization.user if authorization
      
      email = auth_hash.info[:email]
      user = User.where(email: email).first || User.create_user_by_auth_hash(auth_hash)

      user.authorizations.create(provider: auth_hash.provider, uid: auth_hash.uid)
      user
    end

    def create_user_by_auth_hash(auth_hash)
      email = auth_hash.info[:email]
      name = auth_hash.info[:name]
      password = Devise.friendly_token[0, 15]
      User.create!(email: email, name: name, password: password, password_confirmation: password)      
    end
  end
end
