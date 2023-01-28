require 'rails_helper'

RSpec.describe "Users", type: :request do
    before do
        password = Faker::Internet.password(min_length: 6, max_length: 72)
        @user = FactoryBot.create(:user, password: password)
        post signup_path, params: { sessions: @user.attributes.merge({ password: password }) }
    end

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

    # * SHOW
    context "GET show" do
        before do
            get user_path(@user)
        end

        it "should render a show template" do
            expect(response).to render_template(:show)
            expect(response).to have_http_status(:ok)
        end

        it "should render the instance that was passed in the params" do
            # it could be any attribute, not only ITS
            expect(response.body).to include("#{@user.its}")
        end
    end

    # * EDIT
    context "GET edit" do
        before do
            get edit_user_path(@user)
        end

        it "should render render an edit template" do
            expect(response).to render_template(:edit)
            expect(response).to have_http_status(:ok)
        end

        it "should render the instance that was passed in the params" do
            # it could be any attribute, not only name
            expect(response.body).to include("#{@user.name}")
        end
    end

    # * UPDATE
    context "PATCH update" do
        context "with valid attributes" do
            it "should redirect to updated user" do
                new_password = Faker::Internet.password(min_length: 6, max_length: 72)
                password = new_password
                password_confirmation = new_password

                hash_params = {password: password, password_confirmation: password_confirmation}
                user_params = @user.attributes.merge(hash_params)

                patch user_path(@user), params: { user: user_params }

                expect(response).to redirect_to @user
            end
        end

        context "with invalid attributes" do
            it "should render an edit template" do
                password = nil
                password_confirmation = nil

                hash_params = {password: password, password_confirmation: password_confirmation}
                user_params = @user.attributes.merge(hash_params)

                patch user_path(@user), params: { user: user_params }

                expect(response).to render_template(:edit)
            end
        end
    end

    # * DESTROY
    context "DELETE destroy" do
        before do
            delete user_path(@user)
            @user = User.find_by(id: @user.id)
        end


        it "should destroy the user" do
            expect(@user).to be_nil
        end

        #  if admin deletes other user
        it "should redirect to the login path" do
            expect(response).to redirect_to login_path
        end

        # if admin or user deletes itself
        # it "should redirect to the login path" do
        #     expect(response).to redirect_to login_path
        # end
    end
end