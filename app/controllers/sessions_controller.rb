class SessionsController < ApplicationController
  before_action :logged_in?, only: :new

  def new
  end

  def create
    user = User.find_by(its: params[:sessions][:its])
    if user&.authenticate(params[:sessions][:password])
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
    session[:user_id] = nil
    redirect_to login_path, success: t(".success")
  end
end
