class ThaalisController < ApplicationController
  before_action :authorize
  before_action :authorize_admin_member, only: %i[new create edit update destroy]
  before_action :set_thaali, only: %i[show edit update destroy]
  before_action :check_thaali_for_current_year, only: [:new]
  before_action :set_year, only: %i[complete pending all]

  def index
    @q = Thaali.for_year(CURR_YR).ransack(params[:q])
    query = @q.result(distinct: true)
    turbo_load(query)
  end

  def show
    @transactions = @thaali.transactions.load
    @sabeel = @thaali.sabeel
  end

  def new
    @thaali = @sabeel.thaalis.new

    if @sabeel.took_thaali?
      took_thaali = @thaalis.where(year: PREV_YR).first
      @thaali.number = took_thaali[:number]
      @thaali.size = took_thaali[:size]
    end
  end

  def edit
  end

  def create
    @sabeel = Sabeel.find(params[:sabeel_id])
    @thaali = @sabeel.thaalis.new(thaalis_params)
    @thaali.year = CURR_YR

    if @thaali.valid?
      @thaali.save
      redirect_to @thaali, success: t(".success")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @thaali.update(thaalis_params)
      redirect_to @thaali, success: t(".success")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @thaali.destroy
    redirect_to sabeel_path(@thaali.sabeel), success: t(".success")
  end

  def stats
    years = Thaali.distinct.pluck(:year)
    @years = {}

    years.each do |y|
      thaalis = Thaali.for_year(y)
      @years[y] = {}
      @years[y].store(:total, thaalis.sum(:total))
      @years[y].store(:balance, thaalis.sum(&:balance))
      @years[y].store(:count, thaalis.count)
      @years[y].store(:pending, Thaali.dues_unpaid_for(y).length)
      @years[y].store(:complete, Thaali.dues_cleared_in(y).length)
      SIZES.each do |size|
        @years[y].store(size.to_sym, thaalis.send(size).count)
      end
    end
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
    thaalis = Thaali.for_year(@year)
    turbo_load(thaalis)
  end

  private

  def check_thaali_for_current_year
    @sabeel = Sabeel.find(params[:sabeel_id])
    @thaalis = @sabeel.thaalis

    if @sabeel.taking_thaali?
      message = "Already taking thaali"
      redirect_back fallback_location: sabeel_path(@sabeel), notice: message
    end
  end

  def set_thaali
    @thaali = Thaali.find(params[:id])
  end

  def set_year
    @year = params[:year]
  end

  def thaalis_params
    params.require(:thaali).permit(:number, :size, :total)
  end

  def turbo_load(thaalis)
    respond_to do |format|
      format.html
      format.turbo_stream do
        @pagy, @thaalis = pagy_countless(thaalis.preloading)
      end
    end
  end
end
