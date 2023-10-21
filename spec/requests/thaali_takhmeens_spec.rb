# frozen_string_literal: true

require "rails_helper"

RSpec.describe "ThaaliTakhmeen request" do
  # * Log Out users
  describe "Logged out users cannot access" do
    let(:thaali) { create(:thaali_takhmeen) }

    # * NEW
    describe "GET /new" do
      before { get new_sabeel_takhmeen_path(thaali.sabeel) }

      it { expect(response).to have_http_status(:found) }
      it { expect(response).to redirect_to login_path }
    end

    # * SHOW
    describe "GET /show" do
      before { get takhmeen_path(thaali) }

      it { expect(response).to have_http_status(:found) }
      it { expect(response).to redirect_to login_path }
    end

    # * INDEX
    describe "GET /" do
      before { get root_path }

      it { expect(response).to have_http_status(:found) }
      it { expect(response).to redirect_to login_path }
    end

    # * EDIT
    describe "GET /edit" do
      before { get edit_takhmeen_path(thaali) }

      it { expect(response).to have_http_status(:found) }
      it { expect(response).to redirect_to login_path }
    end

    # * STATS
    describe "GET /stats" do
      before { get takhmeens_stats_path(thaali) }

      it { expect(response).to have_http_status(:found) }
      it { expect(response).to redirect_to login_path }
    end

    # * Complete
    describe "GET /complete" do
      before { get thaali_takhmeens_complete_path(CURR_YR) }

      it { expect(response).to have_http_status(:found) }
      it { expect(response).to redirect_to login_path }
    end

    # * Pending
    describe "GET /pending" do
      before { get thaali_takhmeens_pending_path(PREV_YR) }

      it { expect(response).to have_http_status(:found) }
      it { expect(response).to redirect_to login_path }
    end

    # * All
    describe "GET /all" do
      before { get thaali_takhmeens_all_path(PREV_YR) }

      it { expect(response).to have_http_status(:found) }
      it { expect(response).to redirect_to login_path }
    end
  end

  # * Accessible by all
  describe "'Anyone' who have logged in can access 👉" do
    before do
      user = create(:user)
      post signup_path, params: {sessions: user.attributes.merge({password: user.password})}
    end

    # * INDEX
    describe "GET /index" do
      before { get root_path }

      it { expect(response).to render_template(:index) }
      it { expect(response).to have_http_status(:ok) }
    end

    # * SHOW
    describe "GET /show" do
      let(:thaali) { create(:thaali_takhmeen) }

      before { get takhmeen_path(thaali.id) }

      it { expect(response).to render_template(:show) }
      it { expect(response).to have_http_status(:ok) }
    end

    # * STATISTICS
    describe "GET /stats" do
      before { get takhmeens_stats_path }

      it { expect(response).to render_template(:stats) }
      it { expect(response).to have_http_status(:ok) }
    end

    # * COMPLETE
    describe "GET /complete" do
      before { get thaali_takhmeens_complete_path(CURR_YR) }

      it { expect(response).to render_template(:complete) }
      it { expect(response).to have_http_status(:ok) }
    end

    # * PENDING
    describe "GET /pending" do
      before { get thaali_takhmeens_pending_path(CURR_YR) }

      it { expect(response).to render_template(:pending) }
      it { expect(response).to have_http_status(:ok) }
    end

    # * ALL
    describe "GET /all" do
      before { get thaali_takhmeens_all_path(PREV_YR) }

      it { expect(response).to render_template(:all) }
      it { expect(response).to have_http_status(:ok) }
    end
  end

  # * Accessible by Admins & Members
  describe "'Admin' & 'Member' can access 👉" do
    before do
      user = create(:user_other_than_viewer)
      post signup_path, params: {sessions: user.attributes.merge({password: user.password})}
    end

    # * NEW
    describe "GET /new" do
      context "when sabeel is NOT currently taking thaali" do
        let(:thaali) { create(:previous_takhmeen) }

        before { get new_sabeel_takhmeen_path(thaali.sabeel) }

        it { expect(response).to render_template(:new) }
        it { expect(response).to have_http_status(:ok) }

        describe "but if it was previously registered" do
          it "load the form with previous values" do
            expect(response.body).to include(thaali.number.to_s)
          end
        end
      end

      context "when sabeel has registered for currrent-year thaali" do
        let(:sabeel) { create(:active_sabeel) }

        it "redirects to sabeel show template" do
          get new_sabeel_takhmeen_path(sabeel)
          expect(response).to redirect_to sabeel_path(sabeel)
        end
      end
    end

    # * CREATE
    describe "POST /create" do
      let(:sabeel) { create(:sabeel) }

      context "with valid attributes" do
        before do
          valid_attributes = attributes_for(:thaali_takhmeen)
          post sabeel_takhmeens_path(sabeel), params: {thaali_takhmeen: valid_attributes}
        end

        it "redirects to created thaali" do
          expect(response).to redirect_to takhmeen_path(sabeel.thaali_takhmeens.first)
        end

        it { expect(response).to have_http_status(:found) }
      end

      context "with invalid attributes" do
        before do
          invalid_attributes = attributes_for(:thaali_takhmeen, size: nil)
          post sabeel_takhmeens_path(sabeel), params: {thaali_takhmeen: invalid_attributes}
        end

        it { expect(response).to render_template(:new) }
        it { expect(response).to have_http_status(:unprocessable_entity) }
      end
    end

    # * EDIT
    describe "GET /edit" do
      let(:thaali) { create(:thaali_takhmeen) }

      before { get edit_takhmeen_path(thaali.id) }

      it { expect(response).to render_template(:edit) }
      it { expect(response).to have_http_status(:ok) }
    end

    # * UPDATE
    describe "PATCH /update" do
      let(:thaali) { create(:thaali_takhmeen) }

      context "with valid attributes" do
        before do
          thaali.number = Random.rand(1..100)
          patch takhmeen_path(thaali), params: {thaali_takhmeen: thaali.attributes}
        end

        it "redirects to updated thaali page" do
          expect(response).to redirect_to takhmeen_path("#{thaali.year}-#{thaali.number}")
        end
      end

      context "with invalid attributes" do
        before do
          thaali.total = 0
          patch takhmeen_path(thaali), params: {thaali_takhmeen: thaali.attributes}
        end

        it { expect(response).to render_template(:edit) }
      end
    end

    # * DESTROY
    describe "DELETE /destroy" do
      let(:thaali) { create(:thaali_takhmeen) }

      before { delete takhmeen_path(thaali) }

      it "destroys the thaali" do
        expect(ThaaliTakhmeen.find_by(id: thaali.id)).to be_nil
      end

      it "redirects to its sabeel page" do
        expect(response).to redirect_to sabeel_path(thaali.sabeel)
      end
    end
  end

  # * NOT Accessible by Viewers
  describe "'Viewer' CANNOT access 👉" do
    let(:sabeel) { create(:sabeel) }

    before do
      viewer = create(:viewer_user)
      post signup_path, params: {sessions: viewer.attributes.merge({password: viewer.password})}
    end

    # * NEW
    describe "GET /new" do
      before { get new_sabeel_takhmeen_path(sabeel) }

      it { expect(response).to have_http_status(:found) }

      it { expect(response).to redirect_to root_path }
    end

    # * EDIT
    describe "GET /edit" do
      before do
        thaali = create(:thaali_takhmeen)
        get edit_takhmeen_path(thaali)
      end

      it { expect(response).to have_http_status(:found) }
      it { expect(response).to redirect_to root_path }
    end

    # * DETROY
    describe "DELETE /destroy" do
      let(:thaali) { create(:active_takhmeen) }

      before { delete takhmeen_path(thaali) }

      it "does not destroy the thaali" do
        expect(ThaaliTakhmeen.find_by(id: thaali.id)).to be_persisted
      end

      it { expect(response).to redirect_to root_path }
    end
  end
end
