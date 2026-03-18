class PublicProfilesController < ApplicationController
  before_action :authenticate_user!
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
end
