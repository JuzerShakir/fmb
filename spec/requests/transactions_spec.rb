require 'rails_helper'

RSpec.describe "Transactions", type: :request do
    # * NEW
    context "GET new" do
        before do
            @thaali = FactoryBot.create(:thaali_takhmeen)
            debugger
            get new_sabeel_thaali_takhmeen_transaction_path, params: { id: @thaali.sabeel.id, thaali_takhmeen_id: @thaali.id }
        end

        it "should return a 200 (OK) status code" do
            expect(response).to have_http_status(:ok)
            expect(response).to render_template(:new)
        end
    end
end
