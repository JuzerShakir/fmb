class UsersController < ApplicationController

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

    def destroy
        @user = User.find(params[:id])
        @user.destroy
        #  if admin deletes other user
        redirect_to admin_path, success: "User deleted successfully"
        # if admin or user deletes itself
        # redirect_to login_path
    end

    private

        def user_params
            params.require(:user).permit(:its, :name, :password, :password_confirmation)
        end
end