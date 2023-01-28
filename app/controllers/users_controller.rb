class UsersController < ApplicationController
    before_action :authorize_user, only: [:show, :edit, :update, :destroy]

    def index
        @users = User.all
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
        @user = User.find(params[:id])
    end

    def edit
        @user = User.find(params[:id])
    end

    def update
        @user = User.find(params[:id])
        if @user.update(user_params)
            redirect_to @user, success: "User updated successfully"
        else
            render :edit, status: :unprocessable_entity
        end
    end

    def destroy
        @user = User.find(params[:id])
        @user.destroy
        session[:user_id] = nil
        #  if admin deletes other user
        redirect_to login_path, success: "User deleted successfully"
        # if admin or user deletes itself
        # redirect_to login_path
    end

    private

        def user_params
            params.require(:user).permit(:its, :name, :password, :password_confirmation)
        end
end