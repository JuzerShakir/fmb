# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Thaali edit template" do
  let(:user) { create(:user_admin_or_member) }
  let(:thaali) { create(:thaali) }

  before do
    sign_in(user)
    visit edit_thaali_path(thaali)
  end

  # * Admins & Members
  describe "by Admin or Member" do
    it { expect(page).to have_title "Edit Thaali" }

    describe "updating it" do
      context "with valid values" do
        before do
          fill_in "thaali_number", with: Random.rand(1..400)
          click_on "Update Thaali"
        end

        it { expect(page).to have_content("Thaali updated") }
      end

      context "with invalid values" do
        before do
          fill_in "thaali_number", with: 0
          click_on "Update Thaali"
        end

        it { expect(page).to have_content("Number must be greater than 0") }
      end
    end
  end
end
