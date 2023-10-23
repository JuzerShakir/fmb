class SessionsController < ApplicationController
  before_action :logged_in?, only: :new

  def new
  end

  def create
    user = User.find_by(its: params[:sessions][:its])
    if user&.authenticate(params[:sessions][:password])
      session[:user_id] = user.id
      if user.viewer?
        flash_msg = "Afzalus Salam"
      else
        first_name = user.name.split.first
        flash_msg = "Afzalus Salam, #{first_name} bhai!"
      end

      respond_to do |format|
        format.all { redirect_to root_path(format: :html), success: flash_msg }
      end
    else
      flash.now.alert = "Invalid credentials!"
      render :new, status: :not_found
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_path, success: "Logged Out!"
  end
end
