module Admin
  class RolesController < Admin::BaseController
    def index
      @roles = Role.includes(:users).order(created_at: :desc)
    end

    def new
      @role = Role.new
    end

    def create
      @role = Role.new(role_params)
      if @role.save
        redirect_to admin_roles_path, notice: "Role created successfully."
      else
        render :new, status: :unprocessable_entity
      end
    end
    
    private

    def role_params
      params.require(:role).permit(:name, :description)
    end
  end
end
