class LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    return redirect_to new_profile_path, alert: "Please create your profile first." if current_user.profile.blank?

    profile = Profile.find(params[:public_profile_id])
    liked_user = profile.user
    like = current_user.given_likes.build(liked: liked_user)

    message_key = like.save ? :notice : :alert
    message     = like.save ? "Liked successfully." : like.errors.full_messages.to_sentence

    redirect_back fallback_location: public_profile_path(profile), message_key => message
  end
end
