class HomeController < ApplicationController
  def index
    if user_signed_in? && current_user.profile.blank?
      redirect_to new_profile_path
    end
  end
end
