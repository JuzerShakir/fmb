# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Sabeel New template" do
  before do
    sign_in(user)
    visit new_sabeel_path
  end

  # * Admin
  describe "Admin creating it" do
    let(:user) { create(:admin_user) }

    before do
      attributes_for(:sabeel).except(:apartment).each do |k, v|
        fill_in "sabeel_#{k}", with: v
      end
    end

    it { expect(page).to have_title "New Sabeel" }

    context "with valid values" do
      let(:apartment) { Sabeel.apartments.values.sample }

      before do
        choose apartment
        within("#new_sabeel") { click_on "Create Sabeel" }
      end

      it "redirects to newly created thaali" do
        sabeel = Sabeel.last
        expect(page).to have_current_path sabeel_path(sabeel)
      end

      it { expect(page).to have_content("Sabeel created") }
    end

    context "with invalid values" do
      before do
        within("#new_sabeel") { click_on "Create Sabeel" }
      end

      it { expect(page).to have_content("selection is required") }
    end
  end

  # * Member or Viewer
  describe "visited by Member or Viewer" do
    let(:user) { create(:user_member_or_viewer) }

    it { expect(page).to have_content("Not Authorized") }
    it { expect(page).to have_current_path thaalis_all_path(CURR_YR) }
  end
end
