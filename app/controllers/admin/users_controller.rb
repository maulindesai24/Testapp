module Admin
  class UsersController < Admin::BaseController
    before_action :set_user, only: [:show, :edit, :update, :destroy]

    def index
      @users = User.includes(:role).order(created_at: :desc)
    end

    def show
    end

    def new
      @user = User.new
      @roles = Role.all
    end

    def create
      @user = User.new(user_params)
      if @user.save
        UserMailer.welcome_email(@user).deliver_now
        redirect_to admin_user_path(@user), notice: "User created successfully."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      @roles = Role.all
    end

    def update
      update_params = user_params
      
      # If password is blank, remove it from params so it doesn't get updated
      if update_params[:password].blank?
        update_params.delete(:password)
        update_params.delete(:password_confirmation)
      end

      if @user.update(update_params)
        redirect_to admin_user_path(@user), notice: "User updated successfully."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      if @user == current_user
        redirect_to admin_users_path, alert: "You cannot delete your own account."
      else
        @user.destroy
        redirect_to admin_users_path, notice: "User deleted successfully."
      end
    end

    private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:email, :username, :firstname, :lastname, :password, :password_confirmation, :role_id)
    end
  end
end
