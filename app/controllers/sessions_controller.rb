class SessionsController < ApplicationController
    before_action :logged_in?, only: :new

    def new
    end

    def create
        user = User.find_by_its(params[:sessions][:its])
        if user && user.authenticate(params[:sessions][:password])
            session[:user_id] = user.id
            respond_to do |format|
                first_name = user.name.split.first
                format.all { redirect_to root_path(format: :html), success: "Afzalus Salam, #{first_name} bhai!" }
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