class PublicProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_profile!
  before_action :set_profile, only: %i[show]

  def index
    @profiles = Profile.
      includes(:user).
      where.not(user_id: current_user.id).
      order(created_at: :desc)
  end

  def show
  end

  private

  def set_profile
    @profile = Profile.find(params[:id])
  end

  def ensure_profile!
    return if current_user.profile.present?
    redirect_to new_profile_path, alert: "Please create your profile to start browsing others."
  end
end
