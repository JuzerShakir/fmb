# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Sabeel request" do
  # * Accessible by ALL
  describe "'Anyone' who have logged in can access 👉" do
    # rubocop:disable RSpec/BeforeAfterAll
    before(:all) do
      user = create(:user)
      post signup_path, params: {sessions: user.attributes.merge({password: user.password})}
    end
    # rubocop:enable RSpec/BeforeAfterAll

    # * INDEX
    describe "GET /index" do
      before { get sabeels_path }

      it "renders index template" do
        expect(response).to render_template(:index)
      end

      it "returns with 200 status code" do
        expect(response).to have_http_status(:ok)
      end
    end

    # * SHOW
    describe "GET /show" do
      let(:sabeel) { create(:sabeel) }
      let(:thaalis) { create_list(:thaali_takhmeen, 2, sabeel: sabeel) }

      before { get sabeel_path(sabeel.id) }

      it "renders show template" do
        expect(response).to render_template(:show)
      end

      it "returns with 200 status code" do
        expect(response).to have_http_status(:ok)
      end

      it "renders ITS number" do
        # it could be any attribute, not only ITS
        expect(response.body).to include(sabeel.its.to_s)
      end

      it "renders total takhmeens of a sabeel" do
        count = thaalis.count
        get sabeel_path(sabeel.id)
        expect(response.body).to include("Total number of Takhmeens: #{count}")
      end
    end

    # * STATISTICS
    describe "GET /stats" do
      before { get stats_sabeels_path }

      it "renders stats template" do
        expect(response).to render_template(:stats)
      end

      it "returns with 200 status code" do
        expect(response).to have_http_status(:ok)
      end
    end

    # * ACTIVE
    describe "GET /active" do
      let(:apt) { Sabeel.apartments.keys.sample }

      context "with /html" do
        before { get sabeels_active_path(apt) }

        it "renders active template" do
          expect(response).to render_template(:active)
        end

        it "returns with 200 status code" do
          expect(response).to have_http_status(:ok)
        end
      end

      context "with /pdf" do
        it "returns with 200 status code" do
          get sabeels_active_path(apt, format: :pdf)
          expect(response).to have_http_status(:ok)
        end
      end
    end

    # * INACTIVE
    describe "GET /inactive" do
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
  describe "only 'admin' can access 👉" do
    # rubocop:disable RSpec/BeforeAfterAll
    before(:all) do
      admin = create(:admin_user)
      post signup_path, params: {sessions: admin.attributes.merge({password: admin.password})}
    end
    # rubocop:enable RSpec/BeforeAfterAll

    # * NEW
    describe "GET /new" do
      before { get new_user_path }

      it "renders new template" do
        expect(response).to render_template(:new)
      end

      it "returns with 200 status code" do
        expect(response).to have_http_status(:ok)
      end
    end

    # * CREATE
    describe "POST /create" do
      let(:sabeel) { attributes_for(:sabeel) }

      context "with valid values" do
        before { post sabeels_path, params: {sabeel:} }

        it "redirects to new sabeel" do
          new_sabeel = Sabeel.find_by(its: sabeel[:its])
          expect(response).to redirect_to new_sabeel
        end

        it "returns with 302 redirect status code" do
          expect(response).to have_http_status(:found)
        end
      end

      context "with invalid values" do
        before { post sabeels_path, params: {sabeel: sabeel.merge(name: nil)} }

        it "renders new template" do
          expect(response).to render_template(:new)
        end

        it "returns with 422 status code" do
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    # * DESTROY
    describe "DESTROY /destroy" do
      let(:sabeel) { create(:sabeel) }

      before { delete sabeel_path(sabeel.id) }

      it "destroys the sabeel" do
        expect(Sabeel.find_by(id: sabeel.id)).to be_nil
      end

      it "redirects to the homepage" do
        expect(response).to redirect_to root_path.concat("?format=html")
      end
    end
  end

  describe "'Members' & 'Viewers' CANNOT access 👉" do
    # rubocop:disable RSpec/BeforeAfterAll
    before(:all) do
      user = create(:user_other_than_admin)
      post signup_path, params: {sessions: user.attributes.merge({password: user.password})}
    end
    # rubocop:enable RSpec/BeforeAfterAll

    # * NEW
    describe "GET /new" do
      before { get new_sabeel_path }

      it "returns with 302 redirect status code" do
        expect(response).to have_http_status(:found)
      end

      it "redirects to the root path" do
        expect(response).to redirect_to root_path
      end
    end

    # * DESTROY
    describe "DESTROY /destroy" do
      let(:sabeel) { create(:sabeel) }

      before { delete sabeel_path(sabeel.id) }

      it "is not able to delete sabeel" do
        expect(Sabeel.find_by(id: sabeel.id)).not_to be_nil
      end
    end
  end

  # * Accessible by all user types, except 'viewers'
  describe "'Admin' & 'Member' can access 👉" do
    # rubocop:disable RSpec/BeforeAfterAll
    before(:all) do
      user = create(:user_other_than_viewer)
      post signup_path, params: {sessions: user.attributes.merge({password: user.password})}
    end
    # rubocop:enable RSpec/BeforeAfterAll

    # * EDIT
    describe "GET /edit" do
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
    describe "PATCH /update" do
      let(:sabeel) { create(:sabeel) }

      context "with valid values" do
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

      context "with invalid values" do
        before do
          sabeel.apartment = ""
          patch sabeel_path(sabeel.id), params: {sabeel: sabeel.attributes}
        end

        it "renders edit template" do
          expect(response).to render_template(:edit)
        end
      end
    end
  end

  # * NOT ACCESSIBLE by 'viewer'
  describe "'Viewer' CANNOT access 👉" do
    # rubocop:disable RSpec/BeforeAfterAll
    before(:all) do
      viewer = create(:viewer_user)
      post signup_path, params: {sessions: viewer.attributes.merge({password: viewer.password})}
    end
    # rubocop:enable RSpec/BeforeAfterAll

    # * EDIT
    describe "GET /edit" do
      let(:sabeel) { create(:sabeel) }

      before { get edit_sabeel_path(sabeel.id) }

      it "returns with 302 redirect status code" do
        expect(response).to have_http_status(:found)
      end

      it "redirects to the root path" do
        expect(response).to redirect_to root_path
      end
    end
  end
end
