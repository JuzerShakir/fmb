# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Sabeel request" do
  let(:password) { Faker::Internet.password(min_length: 6, max_length: 72) }

  # * Accessible by all
  describe "'Anyone' can access 👉" do
    before do
      user = create(:user, password:)
      post signup_path, params: {sessions: user.attributes.merge({password:})}
    end

    # * INDEX
    describe "GET index" do
      before do
        get sabeels_path
      end

      it "renders index template" do
        expect(response).to render_template(:index)
      end

      it "returns with 200 status code" do
        expect(response).to have_http_status(:ok)
      end
    end

    # * SHOW
    describe "GET show" do
      let(:sabeel) { create(:sabeel) }

      before do
        3.times do |i|
          create(:thaali_takhmeen, sabeel_id: sabeel.id, year: i)
        end
        get sabeel_path(sabeel.id)
      end

      it "renders show template" do
        expect(response).to render_template(:show)
      end

      it "returns with 200 status code" do
        expect(response).to have_http_status(:ok)
      end

      it "renders the instance that was passed in the params" do
        # it could be any attribute, not only ITS
        expect(response.body).to include(sabeel.its.to_s)
      end

      it "total count of takhmeens of a sabeel" do
        expect(response.body).to include("Total number of Takhmeens: 3")
      end
    end

    # * STATISTICS
    describe "GET stats" do
      before do
        get stats_sabeels_path
      end

      it "renders stats template" do
        expect(response).to render_template(:stats)
      end

      it "returns with 200 status code" do
        expect(response).to have_http_status(:ok)
      end
    end

    # * ACTIVE
    describe "GET active" do
      let(:apt) { Sabeel.apartments.keys.sample }

      context "with html format" do
        before do
          get sabeels_active_path(apt)
        end

        it "renders active template" do
          expect(response).to render_template(:active)
        end

        it "returns with 200 status code" do
          expect(response).to have_http_status(:ok)
        end
      end

      context "with PDF format" do
        it "returns with 200 status code" do
          get sabeels_active_path(apt, format: :pdf)
          expect(response).to have_http_status(:ok)
        end
      end
    end

    # * INACTIVE
    describe "GET inactive" do
      before do
        apts = Sabeel.apartments.keys
        get sabeels_inactive_path(apts.sample)
      end

      it "renders inactive template" do
        expect(response).to render_template(:inactive)
      end

      it "returns with 200 status code" do
        expect(response).to have_http_status(:ok)
      end
    end
  end

  # * Accessible by Admins
  describe "'admin' can access 👉" do
    before do
      admin = create(:admin_user, password:)
      post signup_path, params: {sessions: admin.attributes.merge({password:})}
    end

    # * NEW
    describe "GET new" do
      before { get new_user_path }

      it "renders new template returns with 200 status code" do
        expect(response).to render_template(:new)
      end

      it "returns with 200 status code" do
        expect(response).to have_http_status(:ok)
      end
    end

    # * CREATE
    describe "POST create" do
      let(:sabeel) { Sabeel.find_by(its: valid_attributes[:its]) }

      context "with valid attributes" do
        let(:valid_attributes) { attributes_for(:sabeel) }

        before do
          post sabeels_path, params: {sabeel: valid_attributes}
        end

        it "creates a new Sabeel" do
          expect(sabeel).to be_truthy
        end

        it "redirects to created sabeel" do
          expect(response).to redirect_to sabeel
        end

        it "returns with 302 redirect status code" do
          expect(response).to have_http_status(:found)
        end
      end

      context "with invalid attributes" do
        let(:invalid_attributes) { attributes_for(:sabeel, its: nil) }
        let(:invalid_sabeel) { Sabeel.find_by(its: invalid_attributes[:its]) }

        before do
          post sabeels_path, params: {sabeel: invalid_attributes}
        end

        it "does not create a new Sabeel" do
          expect(invalid_sabeel).to be_nil
        end

        it "renders new template" do
          expect(response).to render_template(:new)
        end

        it "returns with 200 status code" do
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    # * DESTROY
    describe "DELETE destroy" do
      let(:sabeel) { create(:sabeel) }

      before do
        delete sabeel_path(sabeel.id)
      end

      it "destroys the sabeel" do
        expect(Sabeel.find_by(id: sabeel.id)).to be_nil
      end

      it "redirects to the homepage" do
        expect(response).to redirect_to root_path.concat("?format=html")
      end
    end
  end

  # * NOT Accessibile by other types (except admin)
  describe "NOT an 'admin' CANNOT access 👉" do
    before do
      user = create(:user_other_than_admin, password:)
      post signup_path, params: {sessions: user.attributes.merge({password:})}
    end

    # * NEW
    describe "GET new" do
      before { get new_sabeel_path }

      it "does not render a new template" do
        expect(response).not_to render_template(:new)
      end

      it "returns with 302 redirect status code" do
        expect(response).to have_http_status(:found)
      end

      it "redirects to the root path" do
        expect(response).to redirect_to root_path
      end
    end

    # * DESTROY
    describe "DELETE destroy" do
      let(:sabeel) { create(:sabeel) }

      before do
        delete sabeel_path(sabeel.id)
      end

      it "is not able to delete sabeel" do
        expect(Sabeel.find_by(id: sabeel.id)).not_to be_nil
      end
    end
  end

  # * Accessible by all user types, except 'viewers'
  describe "'admin' & 'member' can access 👉" do
    before do
      user = create(:user_other_than_viewer, password:)
      post signup_path, params: {sessions: user.attributes.merge({password:})}
    end

    # * EDIT
    describe "GET edit" do
      let(:sabeel) { create(:sabeel) }

      before do
        get edit_sabeel_path(sabeel.id)
      end

      it "renders edit template" do
        expect(response).to render_template(:edit)
      end

      it "returns with 200 status code" do
        expect(response).to have_http_status(:ok)
      end

      it "renders the instance that was passed in the params" do
        # it could be any attribute, not only apartment
        expect(response.body).to include(sabeel.apartment)
      end
    end

    # * UPDATE
    describe "PATCH update" do
      let(:sabeel) { create(:sabeel) }

      context "with valid attributes" do
        before do
          sabeel.apartment = "mohammedi"
          patch sabeel_path(sabeel.id), params: {sabeel: sabeel.attributes}
        end

        it "redirects to updated sabeel" do
          expect(response).to redirect_to sabeel
        end

        it "shows the updated value" do
          get sabeel_path(sabeel.id)
          expect(response.body).to include("Mohammedi")
        end
      end

      context "with invalid attributes" do
        let(:invalid_attributes) { attributes_for(:sabeel, its: nil) }

        before do
          patch sabeel_path(sabeel.id), params: {sabeel: invalid_attributes}
        end

        it "renders edit template" do
          expect(response).to render_template(:edit)
        end
      end
    end
  end

  # * NOT ACCESSIBLE by 'viewer' types
  describe "'viewer' CANNOT access 👉" do
    before do
      viewer = create(:viewer_user, password:)
      post signup_path, params: {sessions: viewer.attributes.merge({password:})}
    end

    # * EDIT
    describe "GET edit" do
      let(:sabeel) { create(:sabeel) }

      before do
        get edit_sabeel_path(sabeel.id)
      end

      it "does not render an edit template" do
        expect(response).not_to render_template(:edit)
      end

      it "returns with 302 redirect status code" do
        expect(response).to have_http_status(:found)
      end

      it "redirects to the root path" do
        expect(response).to redirect_to root_path
      end
    end
  end
end
