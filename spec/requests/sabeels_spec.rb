require 'rails_helper'

RSpec.describe "Sabeels", type: :request do
    # * INDEX
    context "GET index" do
        before do
            @sabeels = FactoryBot.create_list(:sabeel, 2)
            get all_sabeels_path
        end

        it "should render an index template with 200 status code" do
            expect(response).to render_template(:index)
            expect(response).to have_http_status(:ok)
        end

        it "should display all the sabeels on the index template" do
            @sabeels.each do |sabeel|
                expect(response.body).to include("#{sabeel.hof_name}")
            end
        end
    end

    # * NEW
    context "GET new" do
        before { get new_sabeel_path }

        it "should render a new template with 200 status code" do
            expect(response).to render_template(:new)
            expect(response).to have_http_status(:ok)
        end
    end

    # * CREATE
    context "POST create" do
        before do
          @valid_attributes =  FactoryBot.attributes_for(:sabeel)
          @invalid_attributes = FactoryBot.attributes_for(:sabeel, its: nil)
        end

        context "with valid attributes" do
            before do
              post sabeels_path, params: { sabeel: @valid_attributes }
              @sabeel = Sabeel.find_by(its: @valid_attributes[:its])
            end

            it "should create a new Sabeel" do
              expect(@sabeel).to be_truthy
            end

            it "should redirect to created sabeel" do
              expect(response).to have_http_status(:found)
              expect(response).to redirect_to @sabeel
            end
        end

        context "with invalid attributes" do
            before do
                post sabeels_path, params: { sabeel: @invalid_attributes }
                @invalid_sabeel = Sabeel.find_by(its: @invalid_attributes[:its])
            end

            it "does not create a new Sabeel" do
                expect(@invalid_sabeel).to be_nil
            end

            it "should render a new template" do
                expect(response).to render_template(:new)
                expect(response).to have_http_status(:ok)
            end
        end
    end

    # * SHOW
    context "GET show" do
        before do
            @sabeel = FactoryBot.create(:sabeel)
            3.times do |i|
              FactoryBot.create(:thaali_takhmeen, sabeel_id: @sabeel.id, year: i)
            end
            get sabeel_path(@sabeel.id)
        end

        it "should render a show template" do
            expect(response).to render_template(:show)
            expect(response).to have_http_status(:ok)
        end

        it "should render the instance that was passed in the params" do
            # it could be any attribute, not only ITS
            expect(response.body).to include("#{@sabeel.its}")
        end

        it "total count of takhmeens of a sabeel" do
            expect(response.body).to include("Total Takhmeens 3")
        end
    end

    # * EDIT
    context "GET edit" do
        before do
            @sabeel = FactoryBot.create(:sabeel)
            get edit_sabeel_path(@sabeel.id)
        end

        it "should render render an edit template" do
            expect(response).to render_template(:edit)
            expect(response).to have_http_status(:ok)
        end

        it "should render the instance that was passed in the params" do
            # it could be any attribute, not only apartment
            expect(response.body).to include("#{@sabeel.apartment}")
        end
    end

    # * UPDATE
    context "PATCH update" do
        before do
            @sabeel = FactoryBot.create(:sabeel)
        end

        context "with valid attributes" do
            before do
                @sabeel.apartment = "mohammedi"
                patch sabeel_path(@sabeel.id), params: { sabeel: @sabeel.attributes }
            end

            it "should redirect to updated sabeel" do
                expect(response).to redirect_to @sabeel
            end

            it "should show the updated value" do
                get sabeel_path(@sabeel.id)
                expect(response.body).to include("Mohammedi")
            end
        end

        context "with invalid attributes" do
            before do
                @invalid_attributes = FactoryBot.attributes_for(:sabeel, its: nil)
                patch sabeel_path(@sabeel.id), params: { sabeel: @invalid_attributes }
            end

            it "should render an edit template" do
                expect(response).to render_template(:edit)
            end
        end
    end

    # * DESTROY
    context "DELETE destroy" do
        before do
            sabeel = FactoryBot.create(:sabeel)
            delete sabeel_path(sabeel.id)
            @sabeel = Sabeel.find_by(id: sabeel.id)
        end


        it "should destroy the sabeel" do
            expect(@sabeel).to be_nil
        end

        it "should redirect to the homepage" do
            expect(response).to redirect_to root_path
        end
    end

    # * TRANSACTION
    context "GET transaction" do
        before do
            @sabeel = FactoryBot.create(:sabeel)
            @thaali_takhmeen = FactoryBot.create(:thaali_takhmeen, sabeel_id: @sabeel.id)
            @transactions = FactoryBot.create(:transaction, thaali_takhmeen_id: @thaali_takhmeen.id)
            get sabeel_transactions_path(@sabeel)
        end

        it "should render a transaction template" do
            expect(response).to render_template(:transaction)
            expect(response).to have_http_status(:ok)
        end
    end
end
