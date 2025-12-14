class SessionsController < ApplicationController
  def new
  end

  def create
    login = params[:email]
    user = User.where("LOWER(email) = ? OR LOWER(username) = ?", login.to_s.downcase, login.to_s.downcase).first
    
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to root_path, notice: "Logged in successfully."
    else
      flash.now[:alert] = "Invalid email or password"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session.delete(:user_id)
    redirect_to login_path, notice: "Logged out successfully."
  end
end
