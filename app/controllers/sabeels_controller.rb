class SabeelsController < ApplicationController
    def new
    end

    def create
        sabeel = Sabeel.new(sabeel_params)
        if sabeel.valid?
            sabeel.save
            redirect_to sabeel_path
        else
            render :new
        end
    end

    private
        def sabeel_params
            params.require(:sabeel).permit(:its, :hof_name, :apartment, :flat_no, :mobile, :email)
        end
end