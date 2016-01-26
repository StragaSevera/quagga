class Api::V1::ProfilesController < Api::V1::BaseController
  def me
    @profile = current_resource_owner
    authorize! :show, @profile
    respond_with @profile
  end

  # Не подгружаем самого текущего юзера во имя Оптимизации!
  # Используем новый оператор &. из нового руби
  def index
    authorize! :index, User
    respond_with User.where.not(id: doorkeeper_token&.resource_owner_id)
  end
end