class Authorization < ActiveRecord::Base
  include BCryptable

  attr_accessor :activation_token

  belongs_to :user

  validates :provider, presence: true
  validates :uid, presence: true

  def token_matches?(token)
    BCrypt::Password.new(activation_digest) == token
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

  class << self
    def create_unactivated(auth_hash)
      self.create_from_hash(auth_hash, false)
    end

    def create_activated(auth_hash, user)
      self.create_from_hash(auth_hash, true, user)
    end

    def create_from_hash(auth_hash, activated, user = nil)
      activation_token = generate_token
      activation_digest = generate_digest(activation_token)
      auth = self.create!(provider: auth_hash.provider, 
        uid: auth_hash.uid,
        name: auth_hash[:info].name,
        user: user,
        activation_digest: activation_digest,
        activated: activated)  
      auth.activation_token = activation_token
      auth
    end
  end
end
