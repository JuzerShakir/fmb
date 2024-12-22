# frozen_string_literal: true

require "rails_helper"

RSpec.describe "User destroy" do
  before { sign_in(user) }

  # * Admins & Members
  # * ITSELF
  describe "visited by 'Admin' & 'Member'" do
    let(:user) { create(:user_admin_or_member) }

    before do
      visit user_path(user)
      click_on "Delete"
    end

    describe "destroying self" do
      context "with action buttons" do
        it { within(".modal-footer") { expect(page).to have_css(".btn-light", text: "Cancel") } }
        it { within(".modal-footer") { expect(page).to have_css(".btn-danger", text: "Yes, delete it!") } }
      end

      it "shows confirmation message" do
        within(".modal-body") do
          expect(page).to have_content("Are you sure you want to delete your account? This action cannot be undone.")
        end
      end

      describe "destroy" do
        before { click_on "Yes, delete it!" }

        it { expect(page).to have_current_path login_path }
        it { expect(page).to have_content("Account deleted") }
      end
    end
  end

  # * Admins
  describe "visited by 'Admin'" do
    let(:user) { create(:admin_user) }
    let(:other_user) { create(:user) }

    before do
      visit user_path(other_user)
      click_on "Delete"
    end

    # * OTHER USERS
    describe "destroying other users" do
      it "shows confirmation message" do
        within(".modal-body") do
          expect(page).to have_content("Are you sure you want to delete this User? This action cannot be undone.")
        end
      end

      describe "destroy" do
        before { click_on "Yes, delete it!" }

        it { expect(page).to have_current_path users_path }
        it { expect(page).to have_content("Account deleted") }
      end
    end
  end
end
