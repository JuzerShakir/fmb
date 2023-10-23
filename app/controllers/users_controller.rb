class UsersController < ApplicationController
  before_action :authorize
  before_action :authorize_admin_n_member_as_user, only: [:show, :edit, :update, :destroy]
  before_action :authorize_admin, only: [:new, :create, :index]
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    @users = User.where.not(id: current_user.id)
  end

  def show
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new(user_params)
    if @user.valid?
      @user.save
      redirect_to users_path, success: "User created successfully"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @user.update(user_params)
      redirect_to @user, success: "User updated successfully"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    if current_user.admin? && current_user != @user
      redirect_to users_path, success: "User deleted successfully"
    else
      session[:user_id] = nil
      redirect_to login_path, success: "User deleted successfully"
    end
  end

  private

  def user_params
    params.require(:user).permit(:its, :name, :password, :password_confirmation, :role)
  end

  def set_user
    @user = User.find(params[:id])
  end
end
