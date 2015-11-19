class Users::SessionsController < Devise::SessionsController
# before_filter :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # Конечно, это не хак, но некрасиво как-то просто перекопировать метод предка в потомка с одним изменением.
  # Если в будущих версиях Devise этот метод контроллера сменят, всплывет большая такая ошибка.
  # Вот бы как-то отрефакторить... но super-ом тут не обойдешься - либо перезапишет flash, либо он запишется
  # уже после того, как ответ уйдет.
  # В принципе, можно и без передачи переменной прожить, но интересно же! =-)
  def create
    self.resource = warden.authenticate!(auth_options)
    set_flash_message(:notice, :signed_in, :name => resource.name) if is_flashing_format?
    sign_in(resource_name, resource)
    yield resource if block_given?
    respond_with resource, location: after_sign_in_path_for(resource)
  end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.for(:sign_in) << :attribute
  # end
end
