module Admin
  class RolesController < Admin::BaseController
    def index
      @page = params[:page].to_i <= 0 ? 1 : params[:page].to_i
      @per_page = 10
      offset = (@page - 1) * @per_page
      
      # Start with base query
      @roles = Role.includes(:users)
      
      # Apply search filter
      if params[:search].present?
        search_term = "%#{params[:search]}%"
        @roles = @roles.where(
          "LOWER(roles.name) LIKE LOWER(?) OR LOWER(roles.description) LIKE LOWER(?)",
          search_term, search_term
        )
      end

      if params[:user_count].present?
        case params[:user_count]
        when "0"
          @roles = @roles.left_joins(:users).group('roles.id').having('COUNT(users.id) = 0')
        when "1-5"
          @roles = @roles.left_joins(:users).group('roles.id').having('COUNT(users.id) BETWEEN 1 AND 5')
        when "6-20"
          @roles = @roles.left_joins(:users).group('roles.id').having('COUNT(users.id) BETWEEN 6 AND 20')
        when "20+"
          @roles = @roles.left_joins(:users).group('roles.id').having('COUNT(users.id) > 20')
        end
      end
      
      # Get count AFTER filtering but BEFORE pagination
      @total_roles = @roles.count

      @total_roles = @total_roles.is_a?(Hash) ? @total_roles.keys.size : @total_roles
      @total_pages = (@total_roles.to_f / @per_page).ceil
      
      @roles = @roles.order(created_at: :desc).limit(@per_page).offset(offset)
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
      @role = Role.includes(:users).find(params[:id])
      if @role.users.any?
        user_count = @role.users.count
        redirect_to admin_role_path(@role), alert: "This role cannot be deleted because it has #{user_count} user(s) assigned to it."
      elsif @role.destroy
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
