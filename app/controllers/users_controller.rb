class UsersController < ApplicationController
    before_action :authorize_user, only: [:show, :edit, :update, :destroy]
    before_action :set_user, only: [:show, :edit, :update, :destroy]
    before_action :authorize_admin, only: [:new, :create]

    def index
        @users = User.all.where.not(id: current_user.id)
    end

    def new
        @user = User.new
    end

    def create
        @user = User.new(user_params)
        if @user.valid?
            @user.save
            redirect_to admin_path, success: "User created successfully"
        else
            render :new, status: :unprocessable_entity
        end
    end

    def show
    end

    def edit
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
        session[:user_id] = nil
        #  if admin deletes other user
        redirect_to login_path, success: "User deleted successfully"
        # if admin or user deletes itself
        # redirect_to login_path
    end

    private

        def user_params
            params.require(:user).permit(:its, :name, :password, :password_confirmation, :role)
        end

        def set_user
            @user = User.find(params[:id])
        end

        def authorize_admin
            redirect_to root_path, alert: "Not Authorized!" unless current_user&.admin?
        end
end