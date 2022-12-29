class TransactionsController < ApplicationController
    before_action :set_transaction, only: [:show, :edit, :update, :destroy]
    before_action :check_if_takhmeen_is_complete, only: [:new]

    def index
        @transactions = Transaction.all
    end

    def new
        @transaction = @thaali_takhmeen.transactions.new
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
        @thaali_takhmeen = @transaction.thaali_takhmeen
        @sabeel = @thaali_takhmeen.sabeel
    end

    def edit
    end

    def update
        if @transaction.update(transaction_params)
            flash[:success] = "Transaction updated successfully"
            redirect_to @transaction
        else
            render :edit
        end
    end

    def destroy
        @transaction.destroy
        flash[:success] = "Transaction destroyed successfully"
        redirect_to takhmeen_path(@transaction.thaali_takhmeen)
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
                flash[:notice] = message
                redirect_back fallback_location: takhmeen_path(@thaali_takhmeen.slug)
            end
        end
end
