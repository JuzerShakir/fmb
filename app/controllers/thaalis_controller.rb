class ThaalisController < ApplicationController
  before_action :authorize
  before_action :authorize_admin_member, only: %i[new create edit update destroy]
  before_action :set_thaali, only: %i[show edit update destroy]
  before_action :check_thaali_for_current_year, only: [:new]
  before_action :set_year, only: %i[complete pending all]

  def index
    @active_thaalis = Thaali.includes(:sabeel).for_year(CURR_YR)
    @q = @active_thaalis.ransack(params[:q])

    thaalis = @q.result(distinct: true)
    @pagy, @thaalis = pagy_countless(thaalis)
  end

  def show
    @transactions = @thaali.transactions.order(date: :DESC)
    @sabeel = @thaali.sabeel
  end

  # * TODO fill the values in the view
  def new
    prev_thaali = @sabeel.thaalis.where(year: PREV_YR).first

    if prev_thaali.nil?
      @thaali = @sabeel.thaalis.new
    else
      prev_thaali = prev_thaali.slice(:number, :size)
      @thaali = @sabeel.thaalis.new
      @thaali.number = prev_thaali[:number]
      @thaali.size = prev_thaali[:size]
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
    @thaalis = Thaali.dues_cleared_in(@year).includes(:sabeel)
    set_pagy_thaalis_total
  end

  def pending
    @thaalis = Thaali.dues_unpaid_for(@year).includes(:sabeel)
    set_pagy_thaalis_total
  end

  def all
    @thaalis = Thaali.for_year(@year).includes(:sabeel)
    set_pagy_thaalis_total
  end

  private

  def thaalis_params
    params.require(:thaali).permit(:number, :size, :total)
  end

  def set_thaali
    @thaali = Thaali.find(params[:id])
  end

  def set_year
    @year = params[:year]
  end

  def set_pagy_thaalis_total
    @total = @thaalis.length
    @pagy, @thaalis = pagy_countless(@thaalis)
  end

  def check_thaali_for_current_year
    @sabeel = Sabeel.find(params[:sabeel_id])
    thaali = @sabeel.thaalis.where(year: CURR_YR).first

    unless thaali.nil?
      message = "Already taking thaali"
      redirect_back fallback_location: sabeel_path(@sabeel), notice: message
    end
  end
end
