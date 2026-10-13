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

    if user_signed_in?
      @matched_user_ids =
        Match.
          where(
            "user_one_id = :id OR user_two_id = :id",
            id: current_user.id
          )
          .pluck(:user_one_id, :user_two_id)
          .map do |user_one_id, user_two_id|
            user_one_id == current_user.id ? user_two_id : user_one_id
          end
    else
      @matched_user_ids = []
    end
  end

  def show
    @profile = Profile.find(params[:id])

    @liked =
      user_signed_in? &&
      current_user.given_likes.exists?(liked: @profile.user)

    if user_signed_in? && current_user != @profile.user
      @match = Match.find_between(current_user, @profile.user)
    end
  end

  private

  def set_profile
    @profile = Profile.find(params[:id])
  end
end
