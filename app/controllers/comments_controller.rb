class CommentsController < ApplicationController
  def create
    # Надо бы элегантнее и метапрограммнее, но как - не вижу =-)
    if params["question_id"]
      commentable_type = "Question"
      commentable_id = params["question_id"]
    elsif params["answer_id"]
      commentable_type = "Answer"
      commentable_id = params["answer_id"]
    end
    @comment = current_user.comments.build(comment_params.merge commentable_id: commentable_id, commentable_type: commentable_type)

    @commentable_name = view_context.commentable_compose(commentable_type, commentable_id)
    if @comment.save
      flash.now[:success] = "Комментарий был создан!"
    end
  end

  private
    def comment_params
      params.require(:comment).permit(:body)
    end
end
