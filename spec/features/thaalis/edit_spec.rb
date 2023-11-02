# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Thaali edit template" do
  let(:user) { create(:user_admin_or_member) }
  let(:thaali) { create(:thaali) }

  before do
    page.set_rack_session(user_id: user.id)
    visit edit_thaali_path(thaali)
  end

  # * Admins & Members
  describe "by Admin or Member" do
    describe "updating it" do
      context "with valid values" do
        before do
          fill_in "thaali_number", with: Random.rand(1..400)
          click_button "Update Thaali"
        end

        it { expect(page).to have_content("Thaali updated successfully") }
      end

      context "with invalid values" do
        before do
          fill_in "thaali_number", with: 0
          click_button "Update Thaali"
        end

        it { expect(page).to have_content("Number must be greater than 0") }
      end
    end
  end

  # * Viewer
  describe "visited by Viewer" do
    let(:user) { create(:viewer_user) }

    it { expect(page).to have_content("Not Authorized") }
    it { expect(page).to have_current_path root_path }
  end
end
