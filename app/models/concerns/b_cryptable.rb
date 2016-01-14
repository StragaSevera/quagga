module BCryptable
  extend ActiveSupport::Concern

  include BCrypt

  # Не уверен, стоит ли тестировать,
  # и если стоит, то как?..
  module ClassMethods
    def generate_token
      SecureRandom.urlsafe_base64
    end

    def generate_digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end
  end
end