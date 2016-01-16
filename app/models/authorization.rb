class Authorization < ActiveRecord::Base
  include BCryptable

  attr_accessor :activation_token

  before_create :make_tokens

  belongs_to :user

  validates :provider, presence: true
  validates :uid, presence: true

  def make_tokens
    self.activation_token = self.class.generate_token
    self.activation_digest = self.class.generate_digest(activation_token)
  end

  def token_matches?(token)
    self.class.check_token_match(token, activation_digest)
  end

  def generate_hash(email)
    OmniAuth::AuthHash.new({
      provider: provider,
      uid: uid,
      info: {
        name: name,
        email: email
      }
    })
  end

  def activate!
    self.update_attribute(:activated, true)
  end

  def connect_by_user(user)
    return false unless user
    self.update_attribute(:user_id, user.id)
    return user
  end

  def connect_by_email(email)
    auth_hash = generate_hash(email)
    self.connect_by_user(User.find_or_create_by_email(auth_hash))
  end

  class << self
    def create_unactivated(auth_hash)
      self.create_from_hash(auth_hash, false)
    end

    def create_activated(auth_hash, user)
      self.create_from_hash(auth_hash, true, user)
    end

    def create_from_hash(auth_hash, activated, user = nil)
      auth = self.create!(provider: auth_hash.provider, 
        uid: auth_hash.uid,
        name: auth_hash[:info].name,
        user: user,
        activated: activated)  
      auth
    end
  end
end
