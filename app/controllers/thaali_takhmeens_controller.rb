class ThaaliTakhmeensController < ApplicationController
    def new
        @sabeel = Sabeel.find(params[:id])
    end

    def create
        @thaali_takhmeen = ThaaliTakhmeen.new(thaali_takhmeen_params)
        @thaali_takhmeen.save
        redirect_to sabeel_thaali_takhmeen_path(@thaali_takhmeen)
    end

    private

        def thaali_takhmeen_params
            params.require(:thaali_takhmeen).permit(:number, :size, :sabeel_id, :total, :year)
        end
end
