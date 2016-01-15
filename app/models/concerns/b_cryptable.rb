module BCryptable
  extend ActiveSupport::Concern

  include BCrypt

  module ClassMethods
    def generate_token
      SecureRandom.urlsafe_base64
    end

    def generate_digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end

    def check_token_match(token, digest)
      BCrypt::Password.new(digest) == token
    end
  end
end