class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  before_action :set_unread_message_count

  def after_sign_in_path_for(resource)
    public_profiles_path
  end

  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end

  private

  def ensure_profile!
    return if current_user.profile.present?
    redirect_to new_profile_path, alert: "Please create your profile."
  end

  def set_unread_message_count
    return unless user_signed_in?

    @unread_message_count =
      Message
        .joins(conversation: :match)
        .where(read_at: nil)
        .where.not(sender_id: current_user.id)
        .where(
          "matches.user_one_id = :id OR matches.user_two_id = :id",
          id: current_user.id
        )
        .count
  end
end
