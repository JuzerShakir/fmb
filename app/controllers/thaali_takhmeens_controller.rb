class ThaaliTakhmeensController < ApplicationController
    def new
        @sabeel = Sabeel.find(params[:id])
    end

    def create
        @thaali_takhmeen = ThaaliTakhmeen.new(thaali_takhmeen_params)
        if @thaali_takhmeen.valid?
            @thaali_takhmeen.save
            redirect_to sabeel_thaali_takhmeen_path(@thaali_takhmeen)
        else
            render :new
        end
    end

    def show
        @thaali_takhmeen = ThaaliTakhmeen.find(params[:id])
    end

    def edit
        @thaali_takhmeen = ThaaliTakhmeen.find(params[:id])
    end

    def update
        @thaali_takhmeen = ThaaliTakhmeen.find(params[:id])
        if @thaali_takhmeen.update(thaali_takhmeen_params)
            redirect_to sabeel_thaali_takhmeen_path(@thaali_takhmeen)
        else
            render :edit
        end
    end

    def destroy
        @thaali_takhmeen = ThaaliTakhmeen.find(params[:id])
        @thaali_takhmeen.destroy
        redirect_to sabeel_path
    end

    private

        def thaali_takhmeen_params
            params.require(:thaali_takhmeen).permit(:number, :size, :sabeel_id, :total, :year)
        end
end
