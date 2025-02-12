# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Thaali Active request" do
  let(:apartment) { Sabeel::APARTMENTS.sample }

  # * NOT ACCESSIBLE
  context "when made by logged out user" do
    before { get sabeels_active_path(apartment) }

    it { expect(response).to have_http_status(:found) }
    it { expect(response).to redirect_to login_path }
  end

  # * ACCESSIBLE
  context "when made by any logged in user" do
    let(:user) { create(:user) }

    before do
      post signup_path, params: {sessions: user.attributes.merge({password: user.password})}
    end

    context "with /html format" do
      before { get sabeels_active_path(apartment) }

      context "with valid apartment" do
        it { expect(response).to render_template(:active) }
        it { expect(response).to have_http_status(:ok) }
      end

      context "with invalid apartment" do
        let(:apartment) { Faker::Lorem.word }

        it { expect(response).not_to render_template(:active) }
        it { expect(response).to have_http_status(:found) }
        it { expect(response).to redirect_to statistics_sabeels_path }
        it { (expect(flash[:notice]).to eq("Invalid Apartment")) }
      end
    end

    context "with /pdf format" do
      before { get sabeels_active_path(apartment, format: :pdf) }

      it { expect(response).to have_http_status(:ok) }
    end
  end
end
