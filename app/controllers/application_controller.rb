require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :gonify_current_user_id

  private
    # Не уверен, правильное ли это решение с точки зрения дизайна,
    # загружать это во всех контроллерах...
    def gonify_current_user_id
      gon.current_user_id = user_signed_in? ? current_user.id : -1
    end
end
