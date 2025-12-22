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
    
    def show
      @role = Role.includes(:users).find(params[:id])
    end

    def edit
      @role = Role.find(params[:id])
    end

    def update
      @role = Role.find(params[:id])
      if @role.update(role_params)
        redirect_to admin_role_path(@role), notice: "Role updated successfully."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @role = Role.find(params[:id])
      if @role.destroy
        redirect_to admin_roles_path, notice: "Role deleted successfully."
      else
        redirect_to admin_role_path(@role), alert: "Cannot delete role: #{@role.errors.full_messages.join(', ')}"
      end
    end

    
    private

    def role_params
      params.require(:role).permit(:name, :description)
    end
  end
end
