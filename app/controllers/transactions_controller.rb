class TransactionsController < ApplicationController
    def new
        @thaali_takhmeen = ThaaliTakhmeen.find(params[:id])
    end
end
