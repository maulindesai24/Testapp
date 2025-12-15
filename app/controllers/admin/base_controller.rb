module Admin
    class BaseController < ApplicationController
      before_action :authenticate_user
      before_action :authorize_admin
  
      private
  
      def authenticate_user
        if current_user.nil?
          redirect_to login_path, alert: "Please log in first"
        end
      end
  
      def authorize_admin
        unless current_user&.admin?
          redirect_to root_path, alert: "You are not authorized to access admin area"
        end
      end
    end
  end
  