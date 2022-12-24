require 'rails_helper'

RSpec.describe "Transactions", type: :request do
    # * NEW
    context "GET new" do
        before do
            @thaali = FactoryBot.create(:thaali_takhmeen)
            get "/thaali_takhmeens/#{@thaali.id}/transactions/new"
        end

        it "should return a 200 (OK) status code" do
            expect(response).to have_http_status(:ok)
            expect(response).to render_template(:new)
        end
    end

    # * CREATE
    context "GET create" do
        before do
            @thaali = FactoryBot.create(:thaali_takhmeen)
        end

        context "with valid attributes" do
            before do
                @valid_attributes = FactoryBot.attributes_for(:transaction, thaali_takhmeen_id: @thaali.id)
                post "/thaali_takhmeens/#{@thaali.id}/transactions", params: { transaction: @valid_attributes }
                @transaction = Transaction.find_by(amount: @valid_attributes[:amount])
            end

            it "should create a new Transaction" do
                expect(@transaction).to be_truthy
            end

            it "should redirect to created thaali" do
              expect(response).to have_http_status(:found)
              expect(response).to redirect_to thaali_takhmeen_path
            end
        end

        context "with invalid attributes" do
            before do
                @invalid_attributes = FactoryBot.attributes_for(:transaction, amount: nil)
                post "/thaali_takhmeens/#{@thaali.id}/transactions", params: { transaction: @invalid_attributes }
                @transaction = Transaction.find_by(on_date: @invalid_attributes[:on_date])
            end

            it "does not create a new Thaali" do
                expect(@transaction).to be_nil
            end

            it "should render a new template" do
                expect(response).to render_template(:new)
                expect(response).to have_http_status(:ok)
            end
      end
    end
end
