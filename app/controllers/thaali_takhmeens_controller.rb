class ThaaliTakhmeensController < ApplicationController
    before_action :set_thaali_takhmeen, only: [:show, :edit, :update, :destroy]

    def new
        @sabeel = Sabeel.find(params[:id])
        @prev_thaali = @sabeel.thaali_takhmeens.where(year: $PREV_YEAR_TAKHMEEN).first
    end

    def create
        @thaali_takhmeen = ThaaliTakhmeen.new(thaali_takhmeen_params)
        if @thaali_takhmeen.valid?
            @thaali_takhmeen.save
            redirect_to @thaali_takhmeen
        else
            render :new
        end
    end

    def show
    end

    def edit
    end

    def update
        if @thaali_takhmeen.update(thaali_takhmeen_params)
            redirect_to @thaali_takhmeen
        else
            render :edit
        end
    end

    def destroy
        @thaali_takhmeen.destroy
        redirect_to sabeel_path
    end

    private

        def thaali_takhmeen_params
            params.require(:thaali_takhmeen).permit(:number, :size, :sabeel_id, :total, :year)
        end

        def set_thaali_takhmeen
            @thaali_takhmeen = ThaaliTakhmeen.find(params[:id])
        end
end
