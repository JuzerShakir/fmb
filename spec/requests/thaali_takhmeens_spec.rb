require 'rails_helper'

RSpec.describe "ThaaliTakhmeens", type: :request do
    # * INDEX
    context "GET index" do
        before do
            @thaalis = FactoryBot.create_list(:thaali_takhmeen_of_current_year, 5)
            get root_path
        end

        it "should render an index template with 200 status code" do
            expect(response).to have_http_status(:ok)
            expect(response).to render_template(:index)
        end

        it "should display all the Thaalis for current takhmeen year" do
            @thaalis.each do |thaali|
                expect(response.body).to include("#{thaali.number}")
            end
        end
    end

    # * NEW
    context "GET new" do
        before do
            @sabeel = FactoryBot.create(:sabeel)
            @valid_attributes = FactoryBot.attributes_for(:thaali_takhmeen, sabeel_id: @sabeel.id)
            @valid_attributes[:year] = $PREV_YEAR_TAKHMEEN
            @thaali = ThaaliTakhmeen.create(@valid_attributes)
            get new_sabeel_takhmeen_path(sabeel_id: @sabeel.id)
        end

        it "should render a new template with 200 status code" do
          expect(response).to have_http_status(:ok)
          expect(response).to render_template(:new)
        end

        context "for previous year thaali" do
            it "should extract that instance" do
              expect(response.body).to include("#{@thaali.number}")
            end
        end
    end

# * CREATE
    context "POST create" do
        before do
            @sabeel = FactoryBot.create(:sabeel)
        end

        context "with valid attributes" do
            before do
              @valid_attributes = FactoryBot.attributes_for(:thaali_takhmeen, sabeel_id: @sabeel.id)
              post sabeel_takhmeens_path(sabeel_id: @sabeel.id), params: { thaali_takhmeen: @valid_attributes }
              @thaali = @sabeel.thaali_takhmeens.first
            end


            it "should create a new Thaali" do
              expect(@thaali).to be_truthy
            end

            it "should redirect to created thaali" do
              expect(response).to have_http_status(:found)
              expect(response).to redirect_to takhmeen_path(@thaali)
            end
        end

        context "with invalid attributes" do
            before do
              @invalid_attributes = FactoryBot.attributes_for(:thaali_takhmeen, sabeel_id: nil)
              post sabeel_takhmeens_path(sabeel_id: @sabeel.id), params: { thaali_takhmeen: @invalid_attributes }
              @thaali =  @sabeel.thaali_takhmeens.first
            end

            it "does not create a new Thaali" do
              expect(@thaali).to be_nil
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
            @thaali = FactoryBot.create(:thaali_takhmeen)
            3.times do |i|
                FactoryBot.create(:transaction, thaali_takhmeen_id: @thaali.id, amount: Random.rand(10..100))
            end
            get takhmeen_path(@thaali.id)
        end

        it "should render a show template" do
            expect(response).to render_template(:show)
            expect(response).to have_http_status(:ok)
        end

        it "should render the instance that was passed in the params" do
            # it could be any attribute, not only number
            expect(response.body).to include("#{@thaali.number}")
        end

        it "total count of transactions of a takhmeen" do
            trans_count = @thaali.transactions.count
            expect(response.body).to include("Total Transactions #{trans_count}")
        end
    end

    # * EDIT
    context "GET edit" do
        before do
            @thaali = FactoryBot.create(:thaali_takhmeen)
            get edit_takhmeen_path(@thaali.id)
        end

        it "should render render an edit template" do
            expect(response).to render_template(:edit)
            expect(response).to have_http_status(:ok)
        end

        it "should render the instance that was passed in the params" do
            # it could be any attribute, not only size
            expect(response.body).to include("#{@thaali.size}")
        end
    end

    # * UPDATE
    context "PATCH update" do
        before do
            @thaali = FactoryBot.create(:thaali_takhmeen)
        end

        context "with valid attributes" do
            before do
                @thaali.number = Random.rand(1..100)
                patch takhmeen_path(@thaali), params: { thaali_takhmeen: @thaali.attributes }
            end


            it "should redirect to updated thaali page" do
                expect(response).to redirect_to takhmeen_path(@thaali)
            end
        end

        context "with invalid attributes" do
            before do
                @thaali.total = 0
                patch takhmeen_path(@thaali), params: { thaali_takhmeen: @thaali.attributes }
            end

          it "should render an edit template" do
                expect(response).to render_template(:edit)
          end
        end
    end

    # * DESTROY
    context "DELETE destroy" do
        before do
            thaali = FactoryBot.create(:thaali_takhmeen)
            delete takhmeen_path(thaali)
            # find method will raise an error
            @thaali = ThaaliTakhmeen.find_by(id: thaali.id)
        end


        it "should destroy the thaali" do
            expect(@thaali).to be_nil
        end

        it "should redirect to its sabeel page" do
            expect(response).to redirect_to sabeel_path
        end
    end
end
