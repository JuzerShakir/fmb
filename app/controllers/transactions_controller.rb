class TransactionsController < ApplicationController
    before_action :set_transaction, only: [:show, :edit, :update, :destroy]

    def index
        @transactions = Transaction.all
    end

    def new
        @transaction = Transaction.new
    end

    def create
        @thaali_takhmeen = ThaaliTakhmeen.find(params[:takhmeen_id])
        @transaction = @thaali_takhmeen.transactions.new(transaction_params)

        if @transaction.valid?
            @transaction.save
            flash[:success] = "Transaction created successfully"
            redirect_to @transaction
        else
            render :new
        end
    end

    def show
    end

    def edit
    end

    def update
        if @transaction.update(transaction_params)
            redirect_to @transaction
        else
            render :edit
        end
    end

    def destroy
        @transaction.destroy
        redirect_to takhmeen_path
    end

    private
        def transaction_params
            params.require(:transaction).permit(:amount, :on_date, :mode, :recipe_no)
        end

        def set_transaction
            @transaction = Transaction.find(params[:id])
        end
end
