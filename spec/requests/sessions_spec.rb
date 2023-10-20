# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Session request" do
  let(:user) { create(:user) }

  describe "Logged out users can access 👉" do
    # * NEW
    describe "GET /new" do
      before { get login_path }

      it { expect(response).to render_template(:new) }
      it { expect(response).to have_http_status(:ok) }
    end
  end

  describe "Logged in users cannot access 👉" do
    before do
      post signup_path, params: {sessions: user.attributes.merge({password: user.password})}
      get login_path
    end

    # * NEW
    describe "GET /new" do
      it { expect(response).to redirect_to root_path }
      it { expect(response).to have_http_status(:found) }
    end
  end
end
