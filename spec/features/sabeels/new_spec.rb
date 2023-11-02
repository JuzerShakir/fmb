# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Sabeel New template" do
  before do
    page.set_rack_session(user_id: user.id)
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

    context "with valid values" do
      let(:apartment) { APARTMENTS.sample.to_s.titleize }

      before do
        select apartment, from: :sabeel_apartment
        click_button "Create Sabeel"
      end

      it "redirects to newly created thaali" do
        sabeel = Sabeel.last
        expect(page).to have_current_path sabeel_path(sabeel)
      end

      it { expect(page).to have_content("Sabeel created successfully") }
    end

    context "with invalid values" do
      before { click_button "Create Sabeel" }

      it { expect(page).to have_content("selection is required") }
    end
  end

  # * Member or Viewer
  describe "visited by Member or Viewer" do
    let(:user) { create(:user_member_or_viewer) }

    it { expect(page).to have_content("Not Authorized") }
    it { expect(page).to have_current_path root_path }
  end
end
