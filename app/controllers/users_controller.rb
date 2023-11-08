class UsersController < ApplicationController
  load_and_authorize_resource

  def index
    @users = User.where.not(id: current_user.id)
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to users_path, success: t(".success")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @user.update(user_params)
      redirect_to @user, success: t(".success")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    if current_user.is?("admin") && current_user.id != @user&.id
      redirect_to users_path, success: t(".non_self")
    else
      session[:user_id] = nil
      redirect_to login_path, success: t(".self")
    end
  end

  private

  def user_params
    params.require(:user).permit(:its, :name, :password, :password_confirmation, :role_ids)
  end
end
