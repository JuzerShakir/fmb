class SabeelsController < ApplicationController
  load_and_authorize_resource
  before_action :set_apt, only: %i[active inactive]

  def index
    @q = @sabeels.ransack(params[:q])
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
  end

  def new
  end

  def edit
  end

  def create
    if @sabeel.save
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
      format.all { redirect_to sabeels_path(format: :html), success: t(".success") }
    end
  end

  def active
    @sabeels = Sabeel.where(apartment: @apt).taking_thaali

    respond_to do |format|
      format.html
      format.turbo_stream do
        @pagy, @sabeels = pagy_countless(@sabeels)
      end
      format.pdf do
        pdf = ActiveSabeels.new(@sabeels.preload(:thaalis), @apt)
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

  def set_apt
    @apt = params[:apt]
  end
end
