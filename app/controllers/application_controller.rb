class ApplicationController < ActionController::Base
    include Pagy::Backend
    add_flash_types :success, :notice

    private

        def current_user
            @current_user ||= User.find(session[:user_id]) if session[:user_id]
        end

        helper_method :current_user

        def logged_in?
            redirect_to root_path, notice: "Already logged in!" if session[:user_id]
        end

        def authorize
            redirect_to login_path, alert: "Not Authorized!" if current_user.nil?
        end

        def authorize_admin_member
            un_authorize_redirect if current_user&.viewer?
        end

        def authorize_member_viewer
            if (current_user&.member? && current_user.its.to_s != params[:id]) || current_user&.viewer?
                flash[:alert] = "Not Authorized!"
                redirect_to root_path
            end
        end

        def authorize_admin
            un_authorize_redirect unless current_user&.admin?
        end

        def un_authorize_redirect
            previuos_path = request.referer || root_path
            flash[:alert] = "Not Authorized!"
            redirect_to previuos_path
        end
end
