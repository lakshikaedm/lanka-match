class ProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_profile, only: %i[show edit update]

  def new
    if current_user.profile.present?
      redirect_to profile_path, notice: "You already have a profile."
    else
      @profile = current_user.build_profile
    end
  end

  def create
    if current_user.profile.present?
      redirect_to profile_path, notice: "Profile already exists."
      return
    end

    @profile = current_user.build_profile(profile_params)

    if @profile.save
      redirect_to profile_path, notice: "Profile created successfully."
    else
      render :new, status: :unprocessable_content
    end
  end

  def edit
  end

  def update
    if @profile.update(profile_params)
      redirect_to profile_path, notice: "Profile updated successfully."
    else
      render :edit, status: :unprocessable_content
    end
  end

  def show
  end

  private

  def set_profile
    @profile = current_user.profile
    redirect_to new_profile_path, notice: "Please create your profile first." if @profile.blank?
  end

  def profile_params
    params.require(:profile).permit(:display_name, :birth_date, :gender, :location, :bio, :occupation)
  end
end
