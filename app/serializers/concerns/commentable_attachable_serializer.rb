module CommentableAttachableSerializer
  extend ActiveSupport::Concern

  included do
    attributes :id, :body, :created_at, :updated_at

    has_many :attachments
    has_many :comments
  end
end