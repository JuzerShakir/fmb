class SessionsController < ApplicationController
  before_action :logged_in?, only: :new

  def new
  end

  def create
    user = User.authenticate_by(user_params)
    if user
      session[:user_id] = user.id

      respond_to do |format|
        format.all { redirect_to root_path(format: :html), success: t(".success") }
      end
    else
      flash.now.alert = t(".error")
      render :new, status: :not_found
    end
  end

  def destroy
    Rails.cache.delete("user_#{current_user.id}_role")
    session[:user_id] = nil
    redirect_to login_path, success: t(".success")
  end

  private

  def user_params
    params.require(:sessions).permit(:its, :password)
  end
end
