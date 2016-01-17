class CommentsController < ApplicationController
  before_action :get_commentables
  authorize_resource
  
  respond_to :js

  def create
    respond_with @comment = current_user.comments.create(comment_params)
  end

  private
    def comment_params
      params.require(:comment).permit(:body).merge({commentable_id: @commentable_id, commentable_type: @commentable_type})
    end

    def get_commentables
      path = request.original_fullpath
      regexp = %r|/(.*?)/|
      klass = regexp.match(path)[1]
      @commentable_type = klass.singularize.capitalize
      @commentable_id = params[klass.singularize + "_id"]
      @commentable_name = view_context.commentable_compose(@commentable_type, @commentable_id)
    end
end
