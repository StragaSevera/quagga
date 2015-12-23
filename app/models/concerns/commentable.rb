module Commentable
  extend ActiveSupport::Concern
  
  included do
    has_many :comments, -> { order("id ASC")}, as: :commentable
  end
end