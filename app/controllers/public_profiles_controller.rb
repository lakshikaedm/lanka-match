class PublicProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_profile!
  before_action :set_profile, only: %i[show]

  def index
    @profiles = Profile.
                includes(:user).
                where.not(user_id: current_user.id).
                order(created_at: :desc)
    @liked_user_ids = user_signed_in? ?
                      current_user.
                      given_likes.pluck(:liked_id).
                      to_set : Set.new
  end

  def show
    @profile = Profile.find(params[:id])
    @liked   = user_signed_in? && current_user.given_likes.exists?(liked: @profile.user)
  end

  private

  def set_profile
    @profile = Profile.find(params[:id])
  end
end
