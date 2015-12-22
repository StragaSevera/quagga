class CommentsController < ApplicationController
  def create
    @comment = current_user.comments.build(comment_params)
    if @comment.save
      flash.now[:success] = "Ответ был создан!"
    end
  end

  private
    def comment_params
      params.require(:comment).permit(:body, :commentable_id, :commentable_type)
    end
end
