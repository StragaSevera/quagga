class CommentsController < ApplicationController
  before_action :get_commentables
  def create
    @comment = current_user.comments.build(comment_params.merge commentable_id: @commentable_id, commentable_type: @commentable_type)
    @commentable_name = view_context.commentable_compose(@commentable_type, @commentable_id)
    if @comment.save
      flash.now[:success] = "Комментарий был создан!"
    end
  end

  private
    def comment_params
      params.require(:comment).permit(:body)
    end

    def get_commentables
      path = request.original_fullpath
      regexp = %r|/(.*?)/|
      klass = regexp.match(path)[1]
      @commentable_type = klass.singularize.capitalize
      @commentable_id = params[klass.singularize + "_id"]
    end
end
