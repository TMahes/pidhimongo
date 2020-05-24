class RegistrationsController < Devise::RegistrationsController

  private

  def sign_up_params
    params.require(:user).permit( :name,
                                  :email,
                                  :mobile,
                                  :password,
                                  :password_confirmation,
                                  :familyid,
                                  :from_invite)
  end

  def account_update_params
    params.require(:user).permit( :name,
                                  :email,
                                  :mobile,
                                  :password,
                                  :password_confirmation,
                                  :current_password,
                                  :familyid)
  end

  protected


  def after_sign_in_path_for(resource)
    # return the path based on resource
    logger.debug "iiiiiiiiiiiiii#{resource.email}"
    '/profile'  
  end
  def after_inactive_sign_up_path_for(resource)
   flash[:notice] = "Verification Mail sent to your email please verify to login" 
   '/login'  
   end
end
