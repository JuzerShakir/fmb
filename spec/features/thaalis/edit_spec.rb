# frozen_string_literal: true

require "rails_helper"

RSpec.describe "ThaaliTakhmeen edit template" do
  let(:user) { create(:user_other_than_viewer) }
  let(:thaali) { create(:thaali_takhmeen) }

  before do
    page.set_rack_session(user_id: user.id)
    visit edit_takhmeen_path(thaali)
  end

  # * Admins & Members
  describe "Admin or Member" do
    describe "updating it" do
      context "with valid values" do
        before do
          fill_in "thaali_takhmeen_number", with: Random.rand(1..400)
          click_button "Update Thaali takhmeen"
        end

        it { expect(page).to have_content("Thaali updated successfully") }
      end

      context "with invalid values" do
        before do
          fill_in "thaali_takhmeen_number", with: 0
          click_button "Update Thaali takhmeen"
        end

        it { expect(page).to have_content("Number must be greater than 0") }
      end
    end
  end
end
