class TransactionsController < ApplicationController
  load_and_authorize_resource
  before_action :check_if_thaali_has_balance, only: [:new]

  def all
    @q = Transaction.all.ransack(params[:q])
    query = @q.result(distinct: true)

    respond_to do |format|
      format.html
      format.turbo_stream do
        @pagy, @transactions = pagy_countless(query)
      end
    end
  end

  def show
  end

  def new
    @transaction = @thaali.transactions.new
  end

  def edit
  end

  def create
    @thaali = Thaali.find(params[:thaali_id])
    @transaction = @thaali.transactions.new(transaction_params)

    if @transaction.save
      redirect_to @transaction, success: t(".success")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @thaali = @transaction.thaali

    if @transaction.update(transaction_params)
      redirect_to @transaction, success: t(".success")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @transaction.destroy
    redirect_to @transaction.thaali, success: t(".success")
  end

  private

  def transaction_params = params.require(:transaction).permit(:amount, :date, :mode, :receipt_number)

  def check_if_thaali_has_balance
    @thaali = Thaali.find(params[:thaali_id])

    if @thaali.dues_cleared?
      redirect_back fallback_location: @thaali, notice: t(".notice")
    end
  end
end
