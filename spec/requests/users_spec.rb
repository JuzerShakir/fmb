require 'rails_helper'

RSpec.describe "Users", type: :request do

    # * NEW
    context "GET new" do
        before { get new_user_path }

        it "should render a new template with 200 status code" do
            expect(response).to render_template(:new)
            expect(response).to have_http_status(:ok)
        end
    end

    # * CREATE
    context "POST create" do
        before do
            @valid =  FactoryBot.attributes_for(:user)
            @invalid = FactoryBot.attributes_for(:invalid_user)
        end

        context "with valid attributes" do
            before do
                post users_path, params: { user: @valid }
                @user = User.find_by(its: @valid[:its])
            end

            it "should create a new User" do
                expect(@user).to be_truthy
            end

            it "should redirect to index path of User" do
                expect(response).to have_http_status(:found)
                expect(response).to redirect_to admin_path
            end
        end

        context "with invalid attributes" do
            before do
                post users_path, params: { user: @invalid }
                @invalid_user = User.find_by(its: @invalid[:its])
            end

            it "does not create a new User" do
                expect(@invalid_user).to be_nil
            end

            it "should render a new template" do
                expect(response).to render_template(:new)
                expect(response).to have_http_status(:unprocessable_entity)
            end
        end
    end

    # * INDEX
    context "GET index" do
        before { get admin_path }

        it "should render a index template with 200 status code" do
            expect(response).to render_template(:index)
            expect(response).to have_http_status(:ok)
        end
    end
end