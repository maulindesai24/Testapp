class ProfilesController < ApplicationController
  before_action :authorize
  before_action :set_user

  def show
    @user.reload
  end

  def edit
    @countries = Countries.list
  end

  def update
    if @user.update(profile_params)
      redirect_to profile_path, notice: "Profile updated successfully."
    else
      flash.now[:alert] = "There was an error updating your profile. Please check the errors below."
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = current_user
  end

  def profile_params
    params.require(:user).permit(:firstname, :lastname, :bio, :phone, :address, :country, :avatar)
  end
end
