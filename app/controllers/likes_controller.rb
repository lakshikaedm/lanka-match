class LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_profile!
  before_action :set_profile

  def create
    like = current_user.given_likes.build(liked: @profile.user)

    if like.save
      flash[:notice] = "Liked successfully."
    else
      flash[:alert] = like.errors.full_messages.to_sentence
    end

    redirect_back fallback_location: public_profile_path(@profile)
  end

  def destroy
    like = current_user.given_likes.find_by(liked: @profile.user)

    if like&.destroy
      flash[:notice] = "Removed like successfully."
    else
      flash[:alert] = "Could not remove like."
    end

    redirect_back fallback_location: public_profile_path(@profile)
  end

  private

  def set_profile
    @profile = Profile.find(params[:public_profile_id])
  end
end
