class LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    return redirect_to new_profile_path, alert: "Please create your profile first." if current_user.profile.blank?

    profile = Profile.find(params[:public_profile_id])
    liked_user = profile.user

    like = current_user.given_likes.build(liked: liked_user)

    if like.save
      redirect_to public_profile_path(profile), notice: "Liked successfully."
    else
      redirect_to public_profile_path(profile), alert: like.errors.full_messages.to_sentence
    end
  end
end
