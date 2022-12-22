class ThaaliTakhmeensController < ApplicationController
    def new
        @sabeel = Sabeel.find(params[:id])
    end
end
