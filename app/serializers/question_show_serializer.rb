class QuestionShowSerializer < ActiveModel::Serializer
  attributes :title

  include CommentableAttachableSerializer
end