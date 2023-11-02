class ApplicationController < ActionController::Base
  include Pagy::Backend
  add_flash_types :success, :notice

  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  helper_method :current_user

  def logged_in?
    redirect_to root_path, notice: t("flash.active_session") if session[:user_id]
  end

  def authorize
    redirect_to login_path, alert: t("flash.un_authorize") if current_user.nil?
  end

  def authorize_admin_member
    un_authorize_redirect if current_user&.is_viewer?
  end

  def authorize_admin_n_member_as_user
    un_authorize_redirect unless current_user&.is_admin? || (current_user&.is_member? && current_user.its.to_s == params[:id])
  end

  def authorize_admin
    un_authorize_redirect unless current_user&.is_admin?
  end

  def un_authorize_redirect
    previuos_path = request.referer || root_path
    flash[:alert] = t("flash.un_authorize")
    redirect_to previuos_path
  end
end
