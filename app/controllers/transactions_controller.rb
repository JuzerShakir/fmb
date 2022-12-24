class TransactionsController < ApplicationController
    before_action :set_transaction, only: [:show, :edit, :update, :destroy]

    def all
        @transactions = Transaction.all
    end

    def new
        @thaali_takhmeen = ThaaliTakhmeen.find(params[:id])
    end

    def create
        @transaction = Transaction.new(transaction_params)
        if @transaction.valid?
            @transaction.save
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
        redirect_to thaali_takhmeen_path
    end

    private
        def transaction_params
            params.require(:transaction).permit(:amount, :on_date, :mode, :thaali_takhmeen_id, :recipe_no)
        end

        def set_transaction
            @transaction = Transaction.find(params[:id])
        end
end
