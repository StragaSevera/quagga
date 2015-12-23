class CommentsController < ApplicationController
  def create
    @comment = current_user.comments.build(comment_params)
    commentable_type = params[:comment][:commentable_type].underscore
    commentable_id = params[:comment][:commentable_id]
    @commentable_name = view_context.commentable_compose(commentable_type, commentable_id)
    if @comment.save
      flash.now[:success] = "Комментарий был создан!"
    end
  end

  private
    def comment_params
      params.require(:comment).permit(:body, :commentable_id, :commentable_type)
    end
end
