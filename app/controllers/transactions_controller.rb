class TransactionsController < ApplicationController
    def new
        @thaali_takhmeen = ThaaliTakhmeen.find(params[:thaali_takhmeen_id])
    end
end
