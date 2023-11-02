# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Thaali New request" do
  let(:sabeel) { create(:sabeel) }

  # * NOT ACCESSIBLE
  context "when made by logged out user" do
    before { get new_sabeel_thaali_path(sabeel) }

    it { expect(response).to have_http_status(:found) }
    it { expect(response).to redirect_to login_path }
  end

  context "when made by -" do
    before do
      post signup_path, params: {sessions: user.attributes.merge({password: user.password})}
      get new_sabeel_thaali_path(sabeel)
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

      context "when sabeel is currently NOT taking thaali" do
        let(:sabeel) { create(:sabeel_took_thaali) }
        let(:thaali) { sabeel.thaalis.first }

        it { expect(response).to render_template(:new) }
        it { expect(response).to have_http_status(:ok) }

        describe "and if it was previously registered" do
          it "load the form with previous values" do
            expect(response.body).to include(thaali.number.to_s)
          end
        end
      end

      context "when sabeel CURRENTLY taking thaali" do
        let(:sabeel) { create(:sabeel_taking_thaali) }

        it { expect(response).to redirect_to sabeel_path(sabeel) }
      end
    end
  end
end
