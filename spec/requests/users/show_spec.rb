# frozen_string_literal: true

require "rails_helper"

RSpec.describe "User Show request" do
  # * NOT ACCESSIBLE
  context "when made by logged out user" do
    let(:user) { create(:user) }

    before { get user_path(user) }

    it { expect(response).to have_http_status(:found) }
    it { expect(response).to redirect_to login_path }
  end

  context "when made by -" do
    before do
      post signup_path, params: {sessions: user.attributes.merge({password: user.password})}
      get user_path(user)
    end

    # * NOT ACCESSIBLE
    describe "Viewer" do
      let(:user) { create(:viewer_user) }

      it { expect(response).to have_http_status(:found) }
      it { expect(response).to redirect_to thaalis_all_path(CURR_YR) }
    end

    # * NOT ACCESSIBLE
    describe "Member or Viewer" do
      let(:user) { create(:user_member_or_viewer) }
      let(:other_user) { create(:user) }

      before { get user_path(other_user) }

      it { expect(response).to have_http_status(:found) }
      it { expect(response).to redirect_to thaalis_all_path(CURR_YR) }
    end

    # * ACCESSIBLE
    describe "Admin or Member" do
      let(:user) { create(:user_admin_or_member) }

      it { expect(response).to render_template(:show) }
      it { expect(response).to have_http_status(:ok) }
    end

    # * ACCESSIBLE
    describe "Admin can access other users" do
      let(:user) { create(:admin_user) }
      let(:other_user) { create(:user) }

      before { get user_path(other_user) }

      it { expect(response).to render_template(:show) }
      it { expect(response).to have_http_status(:ok) }
    end
  end
end
