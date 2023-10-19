# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Session request" do
  let(:user) { create(:user) }

  describe "'Anyone' who haven't logged in can access 👉" do
    # * NEW
    describe "new action" do
      before { get login_path }

      it "renders new template" do
        expect(response).to render_template(:new)
      end

      it "returns with 200 status code" do
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "Users who have logged in cannot access 👉" do
    before do
      post signup_path, params: {sessions: user.attributes.merge({password: user.password})}
      get login_path
    end

    # * NEW
    describe "new action" do
      it "redirects to root path" do
        expect(response).to redirect_to root_path
      end

      it "returns with 302 redirect status code" do
        expect(response).to have_http_status(:found)
      end
    end
  end
end
