class TransactionsController < ApplicationController
  before_action :authorize
  before_action :authorize_admin_member, except: %i[all show]
  before_action :set_transaction, only: %i[show edit update destroy]
  before_action :check_if_thaali_has_balance, only: [:new]

  def all
    @q = Transaction.includes(:thaali).ransack(params[:q])

    trans = @q.result(distinct: true).order(date: :DESC)
    @pagy, @transactions = pagy_countless(trans)
  end

  def show
    @sabeel = @thaali.sabeel
  end

  def new
    @transaction = @thaali.transactions.new
    @total_balance = @thaali.balance.humanize
  end

  def edit
    @total_balance = (@thaali.balance + @transaction.amount).humanize
  end

  def create
    @thaali = Thaali.find(params[:thaali_id])
    @transaction = @thaali.transactions.new(transaction_params)

    if @transaction.valid?
      @transaction.save
      redirect_to @transaction, success: t(".success")
    else
      @total_balance = @thaali.balance.humanize
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @transaction.update(transaction_params)
      redirect_to @transaction, success: t(".success")
    else
      @total_balance = (@thaali.balance + @transaction.amount_was).humanize
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @transaction.destroy
    redirect_to thaali_path(@thaali), success: t(".success")
  end

  private

  def transaction_params
    params.require(:transaction).permit(:amount, :date, :mode, :recipe_no)
  end

  def set_transaction
    @transaction = Transaction.find(params[:id])
    @thaali = @transaction.thaali
  end

  def check_if_thaali_has_balance
    @thaali = Thaali.find(params[:thaali_id])

    if @thaali.dues_cleared?
      redirect_back fallback_location: thaali_path(@thaali), notice: t(".notice")
    end
  end
end
