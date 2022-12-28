class SabeelsController < ApplicationController
    before_action :set_sabeel, only: [:edit, :update, :show, :destroy]

    def index
        @sabeels = Sabeel.all
    end

    def new
        @sabeel = Sabeel.new
    end

    def create
        @sabeel = Sabeel.new(sabeel_params)
        if @sabeel.valid?
            @sabeel.save
            flash[:success] = "Sabeel created successfully"
            redirect_to @sabeel
        else
            render :new
        end
    end

    def show
        @thaalis = @sabeel.thaali_takhmeens
        @thaali_inactive = @thaalis.in_the_year($CURRENT_YEAR_TAKHMEEN).empty?
    end

    def edit
    end

    def update
        if @sabeel.update(sabeel_params)
            flash[:success] = "Sabeel updated successfully"
            redirect_to @sabeel
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