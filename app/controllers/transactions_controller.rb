class TransactionsController < ApplicationController
    def new
        @thaali_takhmeen = ThaaliTakhmeen.find(params[:id])
    end

    def create
        @transaction = Transaction.new(transaction_params)
        if @transaction.valid?
            @transaction.save
            redirect_to thaali_takhmeen_path
        else
            render :new
        end
    end

    def show
        @transaction = Transaction.find(params[:id])
    end

    def edit
        @transaction = Transaction.find(params[:id])
    end

    def update
        @transaction = Transaction.find(params[:id])

        if @transaction.update(transaction_params)
            redirect_to @transaction
        else
            render :edit
        end
    end

    def destroy
        @transaction = Transaction.find(params[:id])
        @transaction.destroy
        redirect_to thaali_takhmeen_path
    end

    private
        def transaction_params
            params.require(:transaction).permit(:amount, :on_date, :mode, :thaali_takhmeen_id)
        end
end
