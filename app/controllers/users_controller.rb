class UsersController < ApplicationController

    def new
        @user = User.new
    end

    def create
        @user = User.new(user_params)
        if @user.valid?
            @user.save
            redirect_to root_path, success: "User created successfully"
        else
            render :new, status: :unprocessable_entity
        end
    end

    private

        def user_params
            params.require(:user).permit(:its, :name, :password, :password_confirmation)
        end
end