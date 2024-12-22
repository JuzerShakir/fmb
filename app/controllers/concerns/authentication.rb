module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :require_authentication
    helper_method :authenticated?, :current_user
  end

  class_methods do
    def allow_unauthenticated_access(**options)
      skip_before_action :require_authentication, **options
    end
  end

  private

  def authenticated?
    resume_session
  end

  def require_authentication
    resume_session || request_authentication
  end

  def resume_session
    Current.session ||= find_session_by_cookie
  end

  def find_session_by_cookie
    Session.find_by(id: cookies.signed[:session_id]) if cookies.signed[:session_id]
  end

  def request_authentication
    session[:return_to_after_authenticating] = request.url
    redirect_to login_path, alert: t("flash.un_authorize")
  end

  def after_authentication_url
    return_to_url = session.delete(:return_to_after_authenticating)
    return_to_url.present? ? "#{return_to_url}.html" : thaalis_all_path(CURR_YR, format: :html)
  end

  def start_new_session_for(user)
    user.sessions.create!(user_agent: request.user_agent, ip_address: request.remote_ip).tap do |session|
      Current.session = session
      cookies.signed.permanent[:session_id] = {value: session.id, httponly: true, same_site: :lax}
    end
  end

  def terminate_session
    Rails.cache.delete("user_#{current_user.id}_role")
    Current.session.destroy
    cookies.delete(:session_id)
  end

  def return_to_default_path(type: :notice, msg: "flash.active_session")
    flash[type] = t(msg)
    redirect_to thaalis_all_path(CURR_YR)
  end

  def current_user
    @current_user ||= Current.user
  end
end
