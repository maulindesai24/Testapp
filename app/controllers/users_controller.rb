class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      UserMailer.welcome_email(@user).deliver_now
      redirect_to "/login", notice: "User created successfully. Please check your email for welcome instructions."
    else
      render :new
    end
  end

  private
    def user_params
      params.require(:user).permit(:email, :username, :firstname, :lastname, :password, :password_confirmation)
    end
end
