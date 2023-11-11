# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Transaction Edit request" do
  let(:transaction) { create(:transaction) }

  # * NOT ACCESSIBLE
  context "when made by logged out user" do
    before { get edit_transaction_path(transaction) }

    it { expect(response).to have_http_status(:found) }
    it { expect(response).to redirect_to login_path }
  end

  context "when made by -" do
    before do
      post signup_path, params: {sessions: user.attributes.merge({password: user.password})}
      get edit_transaction_path(transaction)
    end

    # * NOT ACCESSIBLE
    describe "Viewer" do
      let(:user) { create(:viewer_user) }

      it { expect(response).to have_http_status(:found) }
      it { expect(response).to redirect_to root_path }
    end

    # * ACCESSIBLE
    describe "Admin or Member" do
      let(:user) { create(:user_admin_or_member) }

      it { expect(response).to render_template(:edit) }
      it { expect(response).to have_http_status(:ok) }
    end
  end
end
