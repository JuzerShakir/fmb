class SabeelsController < ApplicationController
  before_action :authorize
  before_action :authorize_admin, only: %i[new create destroy]
  before_action :authorize_admin_member, only: %i[edit update]
  before_action :set_sabeel, only: %i[show update edit destroy]
  before_action :set_apt, only: %i[active inactive]

  def index
    @q = Sabeel.ransack(params[:q])
    sabeels = @q.result(distinct: true).order(created_at: :DESC)
    @pagy, @sabeels = pagy_countless(sabeels)
  end

  def show
    @thaalis = @sabeel.thaalis.order(year: :DESC)
    @thaali_inactive = @thaalis.for_year(CURR_YR).empty?
  end

  def new
    @sabeel = Sabeel.new
  end

  def edit
  end

  def create
    @sabeel = Sabeel.new(sabeel_params)
    if @sabeel.valid?
      @sabeel.save
      redirect_to @sabeel, success: t(".success")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @sabeel.update(sabeel_params)
      redirect_to @sabeel, success: t(".success")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @sabeel.destroy
    respond_to do |format|
      format.all { redirect_to root_path(format: :html), success: t(".success") }
    end
  end

  def stats
    @apts = {}

    APARTMENTS.each do |apartment|
      total_sabeels = Sabeel.send(apartment)
      active_thaalis = total_sabeels.taking_thaali
      inactive = total_sabeels.not_taking_thaali
      @apts[apartment] = {}
      @apts[apartment].store(:active_thaalis, active_thaalis.count)
      @apts[apartment].store(:total_sabeels, total_sabeels.count)
      @apts[apartment].store(:inactive_thaalis, inactive.count)
      SIZES.each do |size|
        @apts[apartment].store(size.to_sym, active_thaalis.with_thaali_size(size).count)
      end
    end
  end

  def active
    @s = Sabeel.send(@apt).taking_thaali.order(flat_no: :ASC).includes(:thaalis)
    @total = @s.count
    @pagy, @sabeels = pagy_countless(@s)

    if request.format.symbol == :pdf
      pdf = ActiveSabeels.new(@s, @apt)
      send_data pdf.render, filename: "#{@apt}-#{CURR_YR}.pdf",
        type: "application/pdf", disposition: "inline"
    end
  end

  def inactive
    sabeels = Sabeel.not_taking_thaali_in(@apt).order(flat_no: :ASC)
    @total = sabeels.count
    @pagy, @sabeels = pagy_countless(sabeels)
  end

  private

  def sabeel_params
    params.require(:sabeel).permit(:its, :name, :apartment, :flat_no, :mobile, :email)
  end

  def set_sabeel
    @sabeel = Sabeel.find(params[:id])
  end

  def set_apt
    @apt = params[:apt]
  end
end
