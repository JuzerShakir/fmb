class SabeelsController < ApplicationController
  before_action :authorize
  before_action :authorize_admin, only: %i[new create destroy]
  before_action :authorize_admin_member, only: %i[edit update]
  before_action :set_sabeel, only: %i[show update edit destroy]
  before_action :set_apt, only: %i[active inactive]

  def index
    @q = Sabeel.all.ransack(params[:q])
    query = @q.result(distinct: true)

    respond_to do |format|
      format.html
      format.turbo_stream do
        @pagy, @sabeels = pagy_countless(query)
      end
    end
  end

  def show
    @thaalis = @sabeel.thaalis.preload(:transactions)
    @not_taking_thaali = !@sabeel.taking_thaali?
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
      @apts[apartment].store(:active_thaalis, active_thaalis.length)
      @apts[apartment].store(:total_sabeels, total_sabeels.length)
      @apts[apartment].store(:inactive_thaalis, inactive.length)
      SIZES.each do |size|
        @apts[apartment].store(size.to_sym, active_thaalis.with_thaali_size(size).length)
      end
    end
  end

  def active
    @sabeels = Sabeel.send(@apt).taking_thaali.preload(:thaalis)

    respond_to do |format|
      format.html
      format.turbo_stream do
        @pagy, @sabeels = pagy_countless(@sabeels)
      end
      format.pdf do
        pdf = ActiveSabeels.new(@sabeels, @apt)
        send_data pdf.render, filename: "#{@apt}-#{CURR_YR}.pdf",
          type: "application/pdf", disposition: "inline"
      end
    end
  end

  def inactive
    @sabeels = Sabeel.not_taking_thaali_in(@apt)

    respond_to do |format|
      format.html
      format.turbo_stream do
        @pagy, @sabeels = pagy_countless(@sabeels)
      end
    end
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
