class SabeelsController < ApplicationController
    before_action :set_sabeel, only: [:edit, :update, :show, :destroy]

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
        @thaalis = @sabeel.thaali_takhmeens
    end

    def edit
    end

    def update
        if @sabeel.update(sabeel_params)
            redirect_to sabeel_path
        else
            render :edit
        end
    end

    def destroy
        @sabeel.destroy
        # redirect_to root_path
    end

    private
        def sabeel_params
            params.require(:sabeel).permit(:its, :hof_name, :apartment, :flat_no, :mobile, :email)
        end

        def set_sabeel
            @sabeel = Sabeel.find(params[:id])
        end
end