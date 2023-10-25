# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Transaction New request" do
  # * NOT ACCESSIBLE
  context "when made by logged out user" do
    let(:thaali) { create(:thaali_takhmeen) }

    before { get new_takhmeen_transaction_path(thaali) }

    it { expect(response).to have_http_status(:found) }
    it { expect(response).to redirect_to login_path }
  end

  context "when made by -" do
    before do
      post signup_path, params: {sessions: user.attributes.merge({password: user.password})}
      get new_takhmeen_transaction_path(thaali)
    end

    # * NOT ACCESSIBLE
    describe "Viewer" do
      let(:user) { create(:viewer_user) }
      let(:thaali) { create(:thaali_takhmeen) }

      it { expect(response).to have_http_status(:found) }
      it { expect(response).to redirect_to root_path }
    end

    # * ACCESSIBLE
    describe "Admin or Member" do
      let(:user) { create(:user_other_than_viewer) }

      context "when thaali_takhmeen IS COMPLETED" do
        let(:thaali) { create(:completed_takhmeens) }

        it { expect(response).to redirect_to takhmeen_path(thaali) }
      end

      context "when thaali_takhmeen IS NOT COMPLETED" do
        let(:thaali) { create(:thaali_takhmeen) }

        it { expect(response).to render_template(:new) }
        it { expect(response).to have_http_status(:ok) }
      end
    end
  end
end
