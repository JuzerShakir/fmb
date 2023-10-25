class ThaalisController < ApplicationController
  before_action :authorize
  before_action :authorize_admin_member, only: %i[new create edit update destroy]
  before_action :set_thaali, only: %i[show edit update destroy]
  before_action :check_thaali_for_current_year, only: [:new]
  before_action :set_year, only: %i[complete pending all]

  def index
    @active_thaalis = Thaali.includes(:sabeel).in_the_year(CURR_YR)
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
      redirect_to thaali_path(@thaali), success: t(".success")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @thaali.update(thaalis_params)
      redirect_to thaali_path(@thaali), success: t(".success")
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
      thaalis = Thaali.in_the_year(y)
      @years[y] = {}
      @years[y].store(:total, thaalis.pluck(:total).sum)
      @years[y].store(:balance, thaalis.pluck(:balance).sum)
      @years[y].store(:count, thaalis.count)
      @years[y].store(:pending, Thaali.pending_year(y).count)
      @years[y].store(:complete, Thaali.completed_year(y).count)
      Thaali.sizes.keys.each do |size|
        @years[y].store(size.to_sym, thaalis.send(size).count)
      end
    end
  end

  def complete
    @tt = Thaali.includes(:sabeel).completed_year(@year)
    set_pagy_thaalis_total
  end

  def pending
    @tt = Thaali.includes(:sabeel).pending_year(@year)
    set_pagy_thaalis_total
  end

  def all
    @tt = Thaali.includes(:sabeel).in_the_year(@year)
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
    @total = @tt.count
    @pagy, @thaalis = pagy_countless(@tt)
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
