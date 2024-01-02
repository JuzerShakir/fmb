class ThaalisController < ApplicationController
  load_and_authorize_resource

  before_action :check_thaali_for_current_year, only: [:new]
  before_action :set_year, only: %i[complete pending all]

  def show
    @transactions = @thaali.transactions.load
  end

  def new
    @thaali = @sabeel.thaalis.new

    if @sabeel.took_thaali?
      took_thaali = @thaalis.where(year: PREV_YR).first
      @thaali.attributes = took_thaali.slice(:number, :size)
    end
  end

  def edit
  end

  def create
    @sabeel = Sabeel.find(params[:sabeel_id])
    @thaali = @sabeel.thaalis.new(create_params)

    if @thaali.save
      Rails.cache.write("sabeel_#{@sabeel.id}_taking_thaali?", true)
      redirect_to @thaali, success: t(".success")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @thaali.update(update_params)
      redirect_to @thaali, success: t(".success")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @thaali.destroy
    if @thaali.year == CURR_YR
      Rails.cache.write("sabeel_#{@thaali.sabeel_id}_taking_thaali?", false)
    end
    redirect_to sabeel_path(@thaali.sabeel), success: t(".success")
  end

  def complete
    thaalis = Thaali.dues_cleared_in(@year)
    turbo_load(thaalis)
  end

  def pending
    thaalis = Thaali.dues_unpaid_for(@year)
    turbo_load(thaalis)
  end

  def all
    @q = Thaali.for_year(@year).ransack(params[:q])
    query = @q.result(distinct: true)
    turbo_load(query)
  end

  private

  def check_thaali_for_current_year
    @sabeel = Sabeel.find(params[:sabeel_id])
    @thaalis = @sabeel.thaalis

    if @sabeel.taking_thaali?
      message = "Taking thaali"
      redirect_back fallback_location: sabeel_path(@sabeel), notice: message
    end
  end

  def set_year = @year = params[:year]

  def create_params = params.require(:thaali).permit(:number, :size, :total)

  def turbo_load(thaalis)
    respond_to do |format|
      format.html
      format.turbo_stream do
        @pagy, @thaalis = pagy_countless(thaalis.preloading)
      end
    end
  end

  def update_params = params.require(:thaali).permit(:number, :size)
end
