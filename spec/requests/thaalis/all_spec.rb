# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Thaali All request" do
  # * NOT ACCESSIBLE
  context "when made by logged out user" do
    before { get thaalis_all_path(PREV_YR) }

    it { expect(response).to have_http_status(:found) }
    it { expect(response).to redirect_to login_path }
  end

  # * ACCESSIBLE
  context "when made by any logged in user" do
    let(:user) { create(:user) }

    before do
      post signup_path, params: {sessions: user.attributes.merge({password: user.password})}
      get thaalis_all_path(PREV_YR)
    end

    it { expect(response).to render_template(:all) }
    it { expect(response).to have_http_status(:ok) }
  end
end
