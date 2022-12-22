class SabeelsController < ApplicationController
    def new
    end

    def create
        sabeel = Sabeel.new(sabeel_params)
        if sabeel.valid?
            sabeel.save
            redirect_to sabeel_path
        else
            render :new
        end
    end

    def show
        @sabeel = Sabeel.find(params[:id])
    end

    def edit
        @sabeel = Sabeel.find(params[:id])
    end

    def update
        @sabeel = Sabeel.find(params[:id])
        if @sabeel.update(sabeel_params)
            redirect_to sabeel_path
        else
            render :edit
        end
    end

    def destroy
        @sabeel = Sabeel.find(params[:id])
        @sabeel.destroy
        # redirect_to root_path
    end

    private
        def sabeel_params
            params.require(:sabeel).permit(:its, :hof_name, :apartment, :flat_no, :mobile, :email)
        end
end