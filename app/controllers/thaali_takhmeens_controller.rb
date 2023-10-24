class ThaaliTakhmeensController < ApplicationController
  before_action :authorize
  before_action :authorize_admin_member, only: %i[new create edit update destroy]
  before_action :set_thaali_takhmeen, only: %i[show edit update destroy]
  before_action :check_for_current_year_takhmeen, only: [:new]
  before_action :set_year, only: %i[complete pending all]

  def index
    @active_thaalis = ThaaliTakhmeen.includes(:sabeel).in_the_year(CURR_YR)
    @q = @active_thaalis.ransack(params[:q])

    thaalis = @q.result(distinct: true)
    @pagy, @thaalis = pagy_countless(thaalis)
  end

  def show
    @transactions = @thaali_takhmeen.transactions.order(date: :DESC)
    @sabeel = @thaali_takhmeen.sabeel
  end

  # * TODO fill the values in the view
  def new
    prev_takhmeen = @sabeel.thaali_takhmeens.where(year: PREV_YR).first

    if prev_takhmeen.nil?
      @thaali_takhmeen = @sabeel.thaali_takhmeens.new
    else
      prev_takhmeen = prev_takhmeen.slice(:number, :size)
      @thaali_takhmeen = @sabeel.thaali_takhmeens.new
      @thaali_takhmeen.number = prev_takhmeen[:number]
      @thaali_takhmeen.size = prev_takhmeen[:size]
    end
  end

  def edit
  end

  def create
    @sabeel = Sabeel.find(params[:sabeel_id])
    @thaali_takhmeen = @sabeel.thaali_takhmeens.new(thaali_takhmeen_params)
    @thaali_takhmeen.year = CURR_YR

    if @thaali_takhmeen.valid?
      @thaali_takhmeen.save
      redirect_to takhmeen_path(@thaali_takhmeen), success: t(".success")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @thaali_takhmeen.update(thaali_takhmeen_params)
      redirect_to takhmeen_path(@thaali_takhmeen), success: t(".success")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @thaali_takhmeen.destroy
    redirect_to sabeel_path(@thaali_takhmeen.sabeel), success: t(".success")
  end

  def stats
    years = ThaaliTakhmeen.distinct.pluck(:year)
    @years = {}

    years.each do |y|
      takhmeens = ThaaliTakhmeen.in_the_year(y)
      @years[y] = {}
      @years[y].store(:total, takhmeens.pluck(:total).sum)
      @years[y].store(:balance, takhmeens.pluck(:balance).sum)
      @years[y].store(:count, takhmeens.count)
      @years[y].store(:pending, ThaaliTakhmeen.pending_year(y).count)
      @years[y].store(:complete, ThaaliTakhmeen.completed_year(y).count)
      ThaaliTakhmeen.sizes.keys.each do |size|
        @years[y].store(size.to_sym, takhmeens.send(size).count)
      end
    end
  end

  def complete
    @tt = ThaaliTakhmeen.includes(:sabeel).completed_year(@year)
    set_pagy_thaalis_total
  end

  def pending
    @tt = ThaaliTakhmeen.includes(:sabeel).pending_year(@year)
    set_pagy_thaalis_total
  end

  def all
    @tt = ThaaliTakhmeen.includes(:sabeel).in_the_year(@year)
    set_pagy_thaalis_total
  end

  private

  def thaali_takhmeen_params
    params.require(:thaali_takhmeen).permit(:number, :size, :total)
  end

  def set_thaali_takhmeen
    @thaali_takhmeen = ThaaliTakhmeen.find(params[:id])
  end

  def set_year
    @year = params[:year]
  end

  def set_pagy_thaalis_total
    @total = @tt.count
    @pagy, @thaalis = pagy_countless(@tt)
  end

  def check_for_current_year_takhmeen
    @sabeel = Sabeel.find(params[:sabeel_id])
    @cur_takhmeen = @sabeel.thaali_takhmeens.where(year: CURR_YR).first

    unless @cur_takhmeen.nil?
      message = "Takhmeen has already been done for the year: #{CURR_YR}"
      redirect_back fallback_location: sabeel_path(@sabeel), notice: message
    end
  end
end
