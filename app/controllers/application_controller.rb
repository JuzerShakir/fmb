class ApplicationController < ActionController::Base
    include Pagy::Backend
    add_flash_types :success, :notice

    private

        def current_user
            @current_user ||= User.find(session[:user_id]) if session[:user_id]
        end

        helper_method :current_user

        def authorize
            redirect_to login_path, alert: "Not Authorized!" if current_user.nil?
        end

        def authorize_user
            redirect_to root_path, alert: "Not Authorized!" if current_user.its.to_s != params[:id]
        end
end
