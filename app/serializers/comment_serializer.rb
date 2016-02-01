class CommentSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :body, :created_at, :updated_at
end