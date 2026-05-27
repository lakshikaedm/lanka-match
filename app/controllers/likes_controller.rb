class LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_profile!
  before_action :set_profile

  def create
    like = current_user.given_likes.build(liked: @profile.user)

    if like.save
      message = create_match_if_mutual_like ? "It's a match!" : "Liked successfully."
      redirect_back fallback_location: public_profile_path(@profile), notice: message
    else
      redirect_back fallback_location: public_profile_path(@profile), alert: like.errors.full_messages.to_sentence
    end
  end

  def destroy
    like = current_user.given_likes.find_by(liked: @profile.user)

    if like&.destroy
      Match.find_between(current_user, @profile.user)&.destroy
      redirect_back fallback_location: public_profile_path(@profile), notice: "Removed like successfully."
    else
      redirect_back fallback_location: public_profile_path(@profile), alert: "Like not found."
    end
  end

  private

  def set_profile
    @profile = Profile.find(params[:public_profile_id])
  end

  def create_match_if_mutual_like
    return false unless @profile.user.given_likes.exists?(liked: current_user)

    Match.create_between(current_user, @profile.user)
    true
  end
end
