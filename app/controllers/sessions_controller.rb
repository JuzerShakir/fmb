class SessionsController < ApplicationController
    def new
    end

    def create
        user = User.find_by_its(params[:sessions][:its])
        if user && user.authenticate(params[:sessions][:password])
            session[:user_id] = user.id
            respond_to do |format|
                format.all { redirect_to root_path(format: :html), success: "Afzalus Salam, #{user.name}" }
            end
        else
            # @error_message = "Invalid credentials"
            render :new
        end
    end

    def destroy
        session[:user_id] = nil
        redirect_to login_path, success: "Logged Out!"
    end
end