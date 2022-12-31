class TransactionsController < ApplicationController
    before_action :set_transaction, only: [:show, :edit, :update, :destroy]
    before_action :check_if_takhmeen_is_complete, only: [:new]

    def index
        @q = Transaction.ransack(params[:q])
        @transactions = @q.result(distinct: true).order(created_at: :DESC)
    end

    def new
        @transaction = @thaali_takhmeen.transactions.new
        @total_balance = @thaali_takhmeen.balance.humanize
    end

    def create
        @thaali_takhmeen = ThaaliTakhmeen.find(params[:takhmeen_id])
        @transaction = @thaali_takhmeen.transactions.new(transaction_params)

        if @transaction.valid?
            @transaction.save
            redirect_to @transaction, success: "Transaction created successfully"
        else
            render :new
        end
    end

    def show
        @thaali_takhmeen = @transaction.thaali_takhmeen
        @sabeel = @thaali_takhmeen.sabeel
    end

    def edit
        @thaali_takhmeen = @transaction.thaali_takhmeen
        @total_balance = (@thaali_takhmeen.balance + @transaction.amount).humanize
    end

    def update
        if @transaction.update(transaction_params)
            redirect_to @transaction, success: "Transaction updated successfully"
        else
            render :edit
        end
    end

    def destroy
        thaali_takhmeen = @transaction.thaali_takhmeen
        @transaction.destroy
        redirect_to takhmeen_path(thaali_takhmeen), success: "Transaction destroyed successfully"
    end

    private
        def transaction_params
            params.require(:transaction).permit(:amount, :on_date, :mode, :recipe_no)
        end

        def set_transaction
            @transaction = Transaction.find(params[:id])
        end

        def check_if_takhmeen_is_complete
            @thaali_takhmeen = ThaaliTakhmeen.find(params[:takhmeen_id])

            if @thaali_takhmeen.is_complete
                message = "Takhmeen has been paid in full for the thaali number: #{@thaali_takhmeen.number}, for the year: #{@thaali_takhmeen.year}"
                redirect_back fallback_location: takhmeen_path(@thaali_takhmeen), notice: message
            end
        end
end
