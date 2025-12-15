class PasswordResetsController < ApplicationController
  layout 'auth'
  
  def new
  end

  def create
    @user = User.find_by(email: params[:email])

    if @user.present?
      @user.generate_password_reset
      PasswordResetMailer.with(user: @user).reset_password_email.deliver_later
      redirect_to root_path, notice: "Email will be sent with password reset instructions."
    else
      flash.now[:alert] = "There is no account associated with that email address."
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @user = User.find_by(reset_password_token: params[:token])
    redirect_to new_password_reset_path, alert: "Invalid token." if @user.blank?
  end

  def update
    @user = User.find_by(reset_password_token: params[:token])
    
    if @user.password_reset_expired?
      redirect_to new_password_reset_path, alert: "Token has expired."
    elsif @user.present? && @user.update(user_params)
      @user.update(reset_password_token: nil)
      redirect_to login_path, notice: "Password reset successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private
    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end
end
