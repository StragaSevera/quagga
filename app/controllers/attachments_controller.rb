class AttachmentsController < ApplicationController
  before_action :load_attachment
  before_action :check_attachable_user

  respond_to :js

  def destroy
    respond_with @attachment.destroy
  end

  private 
    def load_attachment
      @attachment = Attachment.find(params[:id])
    end

    def check_attachable_user
      redirect_to root_url unless user_signed_in? && @attachment.attachable.user_id == current_user.id
    end
end
