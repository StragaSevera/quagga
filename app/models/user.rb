class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :omniauthable, omniauth_providers: [:facebook, :twitter]
  devise :validatable, password_length: 4..200

  # Зависимость не ставим, ибо информация должна храниться вечно! ;-)
  has_many :questions
  has_many :answers
  has_many :comments
  has_many :authorizations
  has_many :subscriptions, dependent: :destroy

  validates :name, presence: true, length: { in: 2..30 }
  validates :email, length: { in: 2..200 }

  # Стоит ли для оптимизации переделать на мередачу id? Или выигрыша не будет?
  def subscribed?(question)
    subscriptions.exists?(question_id: question.id)
  end

  def subscribe_to(question)
    subscriptions.create(user_id: self.id, question_id: question.id)
  end

  def unsubscribe_from(question)
    subscriptions.where(question_id: question.id).destroy_all
  end

  def toggle_subscription(question)
    if subscribed?(question)
      unsubscribe_from(question)
    else
      subscribe_to(question)
    end
  end

  class << self
    def find_for_oauth(auth_hash)
      authorization = Authorization.where(provider: auth_hash.provider, uid: auth_hash.uid.to_s, activated: true).first
      return authorization.user if authorization

      return unless auth_hash.info[:email]
      user = find_or_create_by_email(auth_hash)

      Authorization.create_activated(auth_hash, user)
      user
    end

    def find_or_create_by_email(auth_hash)
      User.where(email: auth_hash.info[:email]).first || User.create_user_by_auth_hash(auth_hash)
    end

    def create_user_by_auth_hash(auth_hash)
      email = auth_hash.info[:email]
      name = auth_hash.info[:name] || email
      password = Devise.friendly_token[0, 15]
      User.create!(email: email, name: name, password: password, password_confirmation: password)      
    end
  end
end
