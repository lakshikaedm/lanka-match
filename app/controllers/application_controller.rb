class ApplicationController < ActionController::Base
  allow_browser versions: :modern

  def after_sign_in_path_for(resource)
    public_profiles_path
  end

  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end

  private

  def ensure_profile!
    return if current_user.profile.present?
    redirect_to new_profile_path, alert: "Please create your profile."
  end
end
