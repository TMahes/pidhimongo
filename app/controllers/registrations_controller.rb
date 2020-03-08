class RegistrationsController < Devise::RegistrationsController

  private

  def sign_up_params
    params.require(:user).permit( :name,
                                  :email,
                                  :mobile,
                                  :password,
                                  :password_confirmation,
                                  :familyid)
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

  def after_sign_up_path_for(resource)
    '/profile' # Or :prefix_to_your_route
  end
  
end
