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
    @thaali = @transaction.thaali
    @sabeel = @thaali.sabeel
  end

  def new
    @total_balance = @thaali.balance.humanize
    @transaction = @thaali.transactions.new
  end

  def edit
    @thaali = @transaction.thaali
    @total_balance = (@thaali.balance + @transaction.amount).humanize
  end

  def create
    @thaali = Thaali.find(params[:thaali_id])
    @transaction = @thaali.transactions.new(transaction_params)

    if @transaction.save
      redirect_to @transaction, success: t(".success")
    else
      @total_balance = @thaali.balance.humanize
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @thaali = @transaction.thaali

    if @transaction.update(transaction_params)
      redirect_to @transaction, success: t(".success")
    else
      @total_balance = (@thaali.balance + @transaction.amount_was).humanize
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @thaali = @transaction.thaali

    @transaction.destroy
    redirect_to @thaali, success: t(".success")
  end

  private

  def transaction_params
    params.require(:transaction).permit(:amount, :date, :mode, :recipe_no)
  end

  def check_if_thaali_has_balance
    @thaali = Thaali.find(params[:thaali_id])

    if @thaali.dues_cleared?
      redirect_back fallback_location: @thaali, notice: t(".notice")
    end
  end
end
