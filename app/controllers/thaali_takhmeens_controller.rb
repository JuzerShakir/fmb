class ThaaliTakhmeensController < ApplicationController
    before_action :set_thaali_takhmeen, only: [:show, :edit, :update, :destroy]

    def index
        @thaalis = ThaaliTakhmeen.in_the_year($CURRENT_YEAR_TAKHMEEN)
    end

    def new
        @sabeel = Sabeel.find(params[:sabeel_id])
        @prev_thaali = @sabeel.thaali_takhmeens.where(year: $PREV_YEAR_TAKHMEEN).first
        if @prev_thaali.nil?
            @thaali_takhmeen = @sabeel.thaali_takhmeens.new
        end
    end

    def create
        @sabeel = Sabeel.find(params[:sabeel_id])
        @thaali_takhmeen = @sabeel.thaali_takhmeens.new(thaali_takhmeen_params)
        if @thaali_takhmeen.valid?
            @thaali_takhmeen.save
            flash[:success] = "Thaali Takhmeen created successfully"
            redirect_to takhmeen_path(@thaali_takhmeen)
        else
            render :new
        end
    end

    def show
        @transactions = @thaali_takhmeen.transactions
    end

    def edit
    end

    def update
        if @thaali_takhmeen.update(thaali_takhmeen_params)
            redirect_to takhmeen_path(@thaali_takhmeen)
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
            params.require(:thaali_takhmeen).permit(:number, :size, :total, :year)
        end

        def set_thaali_takhmeen
            @thaali_takhmeen = ThaaliTakhmeen.find(params[:id])
        end
end
