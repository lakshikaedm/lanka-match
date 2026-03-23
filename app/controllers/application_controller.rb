class ApplicationController < ActionController::Base
  allow_browser versions: :modern

  private

  def ensure_profile!
    return if current_user.profile.present?
    redirect_to new_profile_path, alert: "Please create your profile."
  end
end
