require 'rails_helper'

RSpec.describe "ThaaliTakhmeens", type: :request do
    # * NEW
    context "GET new" do
        before do
            @sabeel = FactoryBot.create(:sabeel)
            @valid_attributes = FactoryBot.attributes_for(:thaali_takhmeen, sabeel_id: @sabeel.id)
            @valid_attributes[:year] = $PREV_YEAR_TAKHMEEN
            ThaaliTakhmeen.create(@valid_attributes)
            get new_sabeel_thaali_takhmeen_path, params: { id: @sabeel.id }
        end

        it "should return a 200 (OK) status code" do
          expect(response).to have_http_status(:ok)
          expect(response).to render_template(:new)
        end

        context "for previous year thaali" do
            it "should extract that instance" do
              thaali = @sabeel.thaali_takhmeens.where(year: $PREV_YEAR_TAKHMEEN).first
              expect(response.body).to include("#{thaali.number}")
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
              post sabeel_thaali_takhmeens_path, params: { thaali_takhmeen: @valid_attributes }
              @thaali = ThaaliTakhmeen.find_by(number: @valid_attributes[:number])
            end


            it "should create a new Thaali" do
              expect(@thaali).to be_truthy
            end

            it "should redirect to created thaali" do
              expect(response).to have_http_status(:found)
              expect(response).to redirect_to @thaali
            end
        end

        context "with invalid attributes" do
            before do
              @invalid_attributes = FactoryBot.attributes_for(:thaali_takhmeen, sabeel_id: nil)
              post sabeel_thaali_takhmeens_path, params: { thaali_takhmeen: @invalid_attributes }
              @thaali = ThaaliTakhmeen.find_by(number: @invalid_attributes[:number])
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
            get thaali_takhmeen_path(@thaali)
        end

        it "should render a show template" do
            expect(response).to render_template(:show)
            expect(response).to have_http_status(:ok)
        end

        it "should render the instance that was passed in the params" do
            # it could be any attribute, not only number
            expect(response.body).to include("#{@thaali.number}")
        end
    end

    # * EDIT
    context "GET edit" do
        before do
            @sabeel = FactoryBot.create(:sabeel)
            @valid_attributes = FactoryBot.attributes_for(:thaali_takhmeen, sabeel_id: @sabeel.id)
            @thaali = ThaaliTakhmeen.create(@valid_attributes)
            get edit_thaali_takhmeen_path(@thaali)
        end

        it "should render render an edit template" do
            expect(response).to render_template(:edit)
            expect(response).to have_http_status(:ok)
        end

        it "should render the instance that was passed in the params" do
            # it could be any attribute, not only size
            expect(response.body).to include("#{@valid_attributes.fetch(:size)}")
        end
    end

    # * UPDATE
    context "PATCH update" do
        before do
            @sabeel = FactoryBot.create(:sabeel)
            @valid_attributes = FactoryBot.attributes_for(:thaali_takhmeen, sabeel_id: @sabeel.id)
            @thaali = ThaaliTakhmeen.create(@valid_attributes)
        end

        context "with valid attributes" do
            before do
                @valid_attributes[:number] = Random.rand(1..100)
                patch thaali_takhmeen_path(@thaali), params: { thaali_takhmeen: @valid_attributes }
            end


            it "should redirect to updated thaali page" do
                expect(response).to redirect_to @thaali
            end
        end

        context "with invalid attributes" do
            before do
                @invalid_attributes = FactoryBot.attributes_for(:thaali_takhmeen, total: 0)
                patch thaali_takhmeen_path(@thaali), params: { thaali_takhmeen: @invalid_attributes }
            end

          it "should render an edit template" do
                expect(response).to render_template(:edit)
          end
        end
    end

    # * DESTROY
    context "DELETE destroy" do
        before do
            @sabeel = FactoryBot.create(:sabeel)
            @valid_attributes = FactoryBot.attributes_for(:thaali_takhmeen, sabeel_id: @sabeel.id)
            thaali = ThaaliTakhmeen.create(@valid_attributes)
            delete thaali_takhmeen_path(thaali)
            # find method will raise an error
            @thaali = ThaaliTakhmeen.find_by(id: thaali.id)
        end


        it "should destroy the sabeel" do
            expect(@thaali).to be_nil
        end

        it "should redirect to its sabeel page" do
            expect(response).to redirect_to sabeel_path
        end
    end
end
