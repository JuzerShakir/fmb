class ApplicationController < ActionController::Base
  include Pagy::Backend
  add_flash_types :success, :notice
  helper_method :current_user

  rescue_from CanCan::AccessDenied do
    flash[:alert] = t("flash.un_authorize")

    if current_user.nil?
      redirect_to login_path
    else
      redirect_to request.referer || thaalis_all_path(CURR_YR)
    end
  end

  private

  def current_user
    @current_user ||= User.select(:id, :slug).find(session[:user_id]) if session[:user_id]
  end

  def logged_in?
    redirect_to thaalis_all_path(CURR_YR), notice: t("flash.active_session") if session[:user_id]
  end
end
