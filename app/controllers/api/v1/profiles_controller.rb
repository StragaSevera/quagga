class Api::V1::ProfilesController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :doorkeeper_authorize!

  respond_to :json

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

  protected
    def current_resource_owner
      @current_resource_owner ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
    end

    def current_ability
      @ability ||= Ability.new(current_resource_owner)
    end
end