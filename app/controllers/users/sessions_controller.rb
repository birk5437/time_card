class Users::SessionsController < Devise::SessionsController
  include ApplicationHelper

  def create
    # raise "test"
    if params[:blank_me] == ''
      self.resource = warden.authenticate!(auth_options)
      # set_flash_message(:notice, :signed_in) if is_navigational_format?
      sign_in(resource_name, resource)
      if !session[:return_to].blank?
        redirect_to session[:return_to]
        session[:return_to] = nil
      else
        respond_with resource, :location => after_sign_in_path_for(resource)
      end
    else
      # redirect_to "/"
      sign_out_and_redirect(current_user)
      # redirect_to destroy_user_session_path, method: :delete
    end
  end

  def new
    super
  end
end
