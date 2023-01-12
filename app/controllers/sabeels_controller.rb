class SabeelsController < ApplicationController
    before_action :set_sabeel, only: [:show, :update, :edit, :destroy]

    def index
        search_params = params.permit(:format, :page, q: [:hof_name_or_its_cont])
        @q = Sabeel.ransack(search_params[:q])
        sabeels = @q.result(distinct: true).order(created_at: :DESC)
        @pagy, @sabeels = pagy_countless(sabeels, items: 8)
    end

    def new
        @sabeel = Sabeel.new
    end

    def create
        @sabeel = Sabeel.new(sabeel_params)
        if @sabeel.valid?
            @sabeel.save
            redirect_to @sabeel, success: "Sabeel created successfully"
        else
            render :new, status: :unprocessable_entity
        end
    end

    def show
        @thaalis = @sabeel.thaali_takhmeens.order(year: :DESC)
        @thaali_inactive = @thaalis.in_the_year($active_takhmeen).empty?
    end

    def edit
    end

    def update
        if @sabeel.update(sabeel_params)
            redirect_to @sabeel, success: "Sabeel updated successfully"
        else
            render :edit, status: :unprocessable_entity
        end
    end

    def destroy
        @sabeel.destroy
        redirect_to root_path, success: "Sabeel deleted successfully"
    end

    def stats
        apartments = Array.new.push(*$phase_1, *$phase_2, *$phase_3).map(&:to_sym)
        @apts = {}

        apartments.each do |apartment|
            total_sabeels = Sabeel.send(apartment)
            active_takhmeens = total_sabeels.active_takhmeen($active_takhmeen)
            @apts[apartment] = {}
            @apts[apartment].store(:active_takhmeens, active_takhmeens.count)
            @apts[apartment].store(:total_sabeels, total_sabeels.count)
            ThaaliTakhmeen.sizes.keys.each do | size |
                @apts[apartment].store(size.to_sym, active_takhmeens.with_the_size(size).count)
            end
        end
    end

    def active
        @apt = params[:apt]
        sabeels = Sabeel.send(@apt).active_takhmeen($active_takhmeen)
        @total = sabeels.count
        @pagy, @sabeels = pagy_countless(sabeels, items: 8)
    end

    def total
        @apt = params[:apt]
        sabeels = Sabeel.send(@apt)
        @total = sabeels.count
        @pagy, @sabeels = pagy_countless(sabeels, items: 8)
    end

    private
        def sabeel_params
            params.require(:sabeel).permit(:its, :hof_name, :apartment, :flat_no, :mobile, :email)
        end

        def set_sabeel
            @sabeel = Sabeel.find(params[:id])
        end
end