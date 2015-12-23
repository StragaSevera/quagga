module CommentsHelper
  def commentable_compose(type, id)
    "#{type}-#{id}"
  end

  def commentable_name(commentable)
    commentable_compose(commentable.class.name.underscore, commentable.id)
  end
end
