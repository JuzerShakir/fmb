# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Transaction Show request" do
  let(:transaction) { create(:transaction) }

  # * NOT ACCESSIBLE
  context "when made by logged out user" do
    before { get transaction_path(transaction) }

    it { expect(response).to have_http_status(:found) }
    it { expect(response).to redirect_to login_path }
  end

  context "when made by any logged in user" do
    let(:user) { create(:user) }

    before do
      post signup_path, params: {sessions: user.attributes.merge({password: user.password})}
      get transaction_path(transaction)
    end

    # * ACCESSIBLE
    it { expect(response).to render_template(:show) }
    it { expect(response).to have_http_status(:ok) }
  end
end
