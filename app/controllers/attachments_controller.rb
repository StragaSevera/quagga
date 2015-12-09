class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_attachment
  before_action :check_attachable_user

  # Сознательно не удаляем сам загруженный файл,
  # чтобы у модераторов был к нему доступ даже после удаления.
  def destroy
    @attachment.destroy
    flash.now[:success] = "Файл был удален!"
  end

  private 
    def load_attachment
      @attachment = Attachment.find(params[:id])
    end

    def check_attachable_user
      redirect_to root_url unless current_user && @attachment.attachable.user.id == current_user.id
    end
end
