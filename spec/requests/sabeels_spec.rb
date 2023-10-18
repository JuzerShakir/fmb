# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Sabeel request - user type 👉" do
  before do
    @password = Faker::Internet.password(min_length: 6, max_length: 72)
  end

  # * Accessible by all
  context "any user can access 👉" do
    before do
      @user = create(:user, password: @password)
      post signup_path, params: {sessions: @user.attributes.merge({password: @password})}
    end

    # * INDEX
    context "GET index" do
      before do
        create_list(:sabeel, 2)
        get sabeels_path
      end

      it "renders an index template with 200 status code" do
        expect(response).to render_template(:index)
        expect(response).to have_http_status(:ok)
      end
    end

    # * SHOW
    context "GET show" do
      before do
        @sabeel = create(:sabeel)
        3.times do |i|
          create(:thaali_takhmeen, sabeel_id: @sabeel.id, year: i)
        end
        get sabeel_path(@sabeel.id)
      end

      it "renders a show template" do
        expect(response).to render_template(:show)
        expect(response).to have_http_status(:ok)
      end

      it "renders the instance that was passed in the params" do
        # it could be any attribute, not only ITS
        expect(response.body).to include(@sabeel.its.to_s)
      end

      it "total count of takhmeens of a sabeel" do
        expect(response.body).to include("Total number of Takhmeens: 3")
      end
    end

    # * STATISTICS
    context "GET stats" do
      before do
        get stats_sabeels_path
      end

      it "renders a stats template" do
        expect(response).to render_template(:stats)
        expect(response).to have_http_status(:ok)
      end
    end

    # * ACTIVE
    context "GET active" do
      before do
        @apts = Sabeel.apartments.keys
      end

      it "renders a active template" do
        get sabeels_active_path(@apts.sample)
        expect(response).to render_template(:active)
        expect(response).to have_http_status(:ok)
      end

      it "renders a pdf response" do
        get sabeels_active_path(@apts.sample, format: :pdf)
        expect(response).to have_http_status(:ok)
      end
    end

    # * INACTIVE
    context "GET inactive" do
      before do
        apts = Sabeel.apartments.keys
        get sabeels_inactive_path(apts.sample)
      end

      it "renders a inactive template" do
        expect(response).to render_template(:inactive)
        expect(response).to have_http_status(:ok)
      end
    end
  end

  # * Accessible by Admins
  context "'admin' can access 👉" do
    before do
      @admin = create(:admin_user, password: @password)
      post signup_path, params: {sessions: @admin.attributes.merge({password: @password})}
    end

    # * NEW
    context "GET new" do
      before { get new_user_path }

      it "renders a new template with 200 status code" do
        expect(response).to render_template(:new)
        expect(response).to have_http_status(:ok)
      end
    end

    # * CREATE
    context "POST create" do
      before do
        @valid_attributes = attributes_for(:sabeel)
        @invalid_attributes = attributes_for(:sabeel, its: nil)
      end

      context "with valid attributes" do
        before do
          post sabeels_path, params: {sabeel: @valid_attributes}
          @sabeel = Sabeel.find_by(its: @valid_attributes[:its])
        end

        it "creates a new Sabeel" do
          expect(@sabeel).to be_truthy
        end

        it "redirects to created sabeel" do
          expect(response).to have_http_status(:found)
          expect(response).to redirect_to @sabeel
        end
      end

      context "with invalid attributes" do
        before do
          post sabeels_path, params: {sabeel: @invalid_attributes}
          @invalid_sabeel = Sabeel.find_by(its: @invalid_attributes[:its])
        end

        it "does not create a new Sabeel" do
          expect(@invalid_sabeel).to be_nil
        end

        it "renders a new template" do
          expect(response).to render_template(:new)
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    # * DESTROY
    context "DELETE destroy" do
      before do
        sabeel = create(:sabeel)
        delete sabeel_path(sabeel.id)
        @sabeel = Sabeel.find_by(id: sabeel.id)
      end

      it "destroys the sabeel" do
        expect(@sabeel).to be_nil
      end

      it "redirects to the homepage" do
        expect(response).to redirect_to root_path.concat("?format=html")
      end
    end
  end

  # * NOT Accessibile by other types (except admin)
  context "NOT an 'admin' CANNOT access 👉" do
    before do
      @user = create(:user_other_than_admin, password: @password)
      post signup_path, params: {sessions: @user.attributes.merge({password: @password})}
    end

    # * NEW
    context "GET new" do
      before { get new_sabeel_path }

      it "does not render a new template" do
        expect(response).not_to render_template(:new)
      end

      it "responds with status code '302' (found)" do
        expect(response).to have_http_status(:found)
      end

      it "redirects to the root path" do
        expect(response).to redirect_to root_path
      end
    end

    # * DESTROY
    context "DELETE destroy" do
      before do
        @sabeel = create(:sabeel)
        delete sabeel_path(@sabeel.id)
      end

      it "is not able to delete sabeel" do
        expect(@sabeel).to be_persisted
      end

      it "responds with status code '302' (found)" do
        expect(response).to have_http_status(:found)
      end

      it "redirects to the root path" do
        expect(response).to redirect_to root_path
      end
    end
  end

  # * Accessible by all user types, except 'viewers'
  context "'admin' & 'member' can access 👉" do
    before do
      @user = create(:user_other_than_viewer, password: @password)
      post signup_path, params: {sessions: @user.attributes.merge({password: @password})}
    end

    # * EDIT
    context "GET edit" do
      before do
        @sabeel = create(:sabeel)
        get edit_sabeel_path(@sabeel.id)
      end

      it "renders an edit template" do
        expect(response).to render_template(:edit)
        expect(response).to have_http_status(:ok)
      end

      it "renders the instance that was passed in the params" do
        # it could be any attribute, not only apartment
        expect(response.body).to include(@sabeel.apartment)
      end
    end

    # * UPDATE
    context "PATCH update" do
      before do
        @sabeel = create(:sabeel)
      end

      context "with valid attributes" do
        before do
          @sabeel.apartment = "mohammedi"
          patch sabeel_path(@sabeel.id), params: {sabeel: @sabeel.attributes}
        end

        it "redirects to updated sabeel" do
          expect(response).to redirect_to @sabeel
        end

        it "shows the updated value" do
          get sabeel_path(@sabeel.id)
          expect(response.body).to include("Mohammedi")
        end
      end

      context "with invalid attributes" do
        before do
          @invalid_attributes = attributes_for(:sabeel, its: nil)
          patch sabeel_path(@sabeel.id), params: {sabeel: @invalid_attributes}
        end

        it "renders an edit template" do
          expect(response).to render_template(:edit)
        end
      end
    end
  end

  # * NOT ACCESSIBLE by 'viewer' types
  context "'viewer' CANNOT access 👉" do
    before do
      @viewer = create(:viewer_user, password: @password)
      post signup_path, params: {sessions: @viewer.attributes.merge({password: @password})}
    end

    # * EDIT
    context "GET edit" do
      before do
        @sabeel = create(:sabeel)
        get edit_sabeel_path(@sabeel.id)
      end

      it "does not render an edit template" do
        expect(response).not_to render_template(:edit)
      end

      it "responds with status code '302' (found)" do
        expect(response).to have_http_status(:found)
      end

      it "redirects to the root path" do
        expect(response).to redirect_to root_path
      end
    end
  end
end
