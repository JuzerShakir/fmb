class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[new create]
  before_action :return_to_default_path, only: %i[new create], if: -> { authenticated? }
  # rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_url, alert: "Try again later." }

  def new
  end

  def create
    if user ||= User.authenticate_by(user_params)
      start_new_session_for user

      respond_to do |format|
        format.all { redirect_to after_authentication_url, success: t(".success") }
      end
    else
      redirect_to login_path, alert: t(".error")
    end
  end

  def destroy
    terminate_session
    redirect_to login_path, success: t(".success")
  end

  private

  def user_params = params.require(:sessions).permit(:its, :password)
end
