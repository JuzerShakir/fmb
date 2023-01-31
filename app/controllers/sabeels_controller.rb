class SabeelsController < ApplicationController
    before_action :authorize, only: [:index, :show, :stats, :active, :inactive]
    before_action :authorize_admin, only: [:new, :create, :destroy]
    before_action :set_sabeel, only: [:show, :update, :edit, :destroy]
    before_action :set_apt, only: [:active, :inactive]
    # after_action :set_pagy_sabeels_total, only: [:active, :total]

    def index
        search_params = params.permit(:format, :page, q: [:hof_name_or_its_cont])
        @q = Sabeel.ransack(search_params[:q])
        sabeels = @q.result(distinct: true).order(created_at: :DESC)
        @pagy, @sabeels = pagy_countless(sabeels, items: 20)
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
        respond_to do |format|
            format.all { redirect_to root_path(format: :html), success: "Sabeel deleted successfully" }
        end
    end

    def stats
        apartments = Sabeel.apartments.keys.map(&:to_sym)
        @apts = {}

        apartments.each do |apartment|
            total_sabeels = Sabeel.send(apartment)
            active_takhmeens = total_sabeels.active_takhmeen($active_takhmeen)
            inactive = total_sabeels - active_takhmeens
            @apts[apartment] = {}
            @apts[apartment].store(:active_takhmeens, active_takhmeens.count)
            @apts[apartment].store(:total_sabeels, total_sabeels.count)
            @apts[apartment].store(:inactive_takhmeens, inactive.count)
            ThaaliTakhmeen.sizes.keys.each do | size |
                @apts[apartment].store(size.to_sym, active_takhmeens.with_the_size(size).count)
            end
        end
    end

    def active
        @s = Sabeel.send(@apt).active_takhmeen($active_takhmeen).order(flat_no: :ASC).includes(:thaali_takhmeens)
        @total = @s.count
        @pagy, @sabeels = pagy_countless(@s, items: 20)

        if request.format.symbol == :pdf
            pdf = ActiveSabeels.new(@s, @apt)
            send_data pdf.render, filename: "#{@apt}-#{$active_takhmeen}.pdf",
                                type: "application/pdf", disposition: "inline"
        end
    end

    def inactive
        total_sabeels = Sabeel.send(@apt)
        active_takhmeens = total_sabeels.active_takhmeen($active_takhmeen)
        @sabeels = total_sabeels - active_takhmeens
        @total = @sabeels.count
    end

    private
        def sabeel_params
            params.require(:sabeel).permit(:its, :hof_name, :apartment, :flat_no, :mobile, :email)
        end

        def set_sabeel
            @sabeel = Sabeel.find(params[:id])
        end

        def set_apt
            @apt = params[:apt]
        end

        # def set_pagy_sabeels_total
        #     @total = @s.count
        #     @pagy, @sabeels = pagy_countless(@s, items: 20)
        # end
end