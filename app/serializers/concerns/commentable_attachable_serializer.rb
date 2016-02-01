module CommentableAttachableSerializer
  extend ActiveSupport::Concern

  included do
    attributes :id, :body, :created_at, :updated_at

    has_many :attachments
  end
end