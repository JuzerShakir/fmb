# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Navbar" do
  before do
    page.set_rack_session(user_id: user.id)
    visit root_path
  end

  # * Accessibile by ALL
  describe "'Anyone' who have logged in displays" do
    let(:user) { create(:user) }

    # * Statistics
    describe "Statistics dropdown menu" do
      it do
        within("#statistics") { expect(page).to have_link("Sabeels", href: stats_sabeels_path) }
      end

      it do
        within("#statistics") { expect(page).to have_link("Thaali Takhmeen", href: takhmeens_stats_path) }
      end
    end

    # * Resources
    describe "Resources dropdown menu" do
      it do
        within("#resources") { expect(page).to have_link("Sabeels", href: sabeels_path) }
      end

      it do
        within("#resources") { expect(page).to have_link("Thaali Takhmeens", href: root_path) }
      end

      it do
        within("#resources") { expect(page).to have_link("Transactions", href: transactions_all_path) }
      end
    end
  end

  # * Admin
  context "when admin" do
    describe "has logged in, it displays" do
      let(:user) { create(:admin_user) }

      it do
        within(".navbar-nav") { expect(page).to have_css("#admin", text: "Admin") }
      end

      # * New Sabeel
      it do
        within(".navbar-nav") { expect(page).to have_link("Create Sabeel", href: new_sabeel_path) }
      end

      # * My Profile
      it do
        within("#admin") { expect(page).to have_link("My Profile", href: user_path(user)) }
      end

      # * New User
      it do
        within("#admin") { expect(page).to have_link("New User", href: new_user_path) }
      end

      # * Home
      it do
        within("#admin") { expect(page).to have_link("Home", href: users_path) }
      end

      # * Log Out
      it do
        within("#admin") { expect(page).to have_link("Log out", href: destroy_path) }
      end
    end
  end

  # * Member
  context "when Member" do
    let(:user) { create(:member_user) }

    describe "it displays" do
      it do
        within(".navbar-nav") { expect(page).to have_css("#member", text: "Member") }
      end

      # * My Profile
      it do
        within("#member") { expect(page).to have_link("My Profile", href: user_path(user)) }
      end

      # * Log Out
      it do
        within("#member") { expect(page).to have_link("Log out", href: destroy_path) }
      end
    end

    describe "doesn't display" do
      # * Home
      it do
        within("#member") { expect(page).not_to have_content("Home") }
      end
    end

    # * New User
    it do
      within("#member") { expect(page).not_to have_content("New User") }
    end
  end

  # * Viewer
  context "when Viewer, it displays" do
    let(:user) { create(:viewer_user) }

    it "have 'viewer' id" do
      within(".navbar-nav") { expect(page).to have_css("#viewer") }
    end

    # * Log Out
    it do
      within("#viewer") { expect(page).to have_link("Log out", href: destroy_path) }
    end

    # * My Profile
    it do
      within("#viewer") { expect(page).not_to have_content("My Profile") }
    end

    # * Home
    it do
      within("#viewer") { expect(page).not_to have_content("Home") }
    end

    # * New User
    it do
      within("#viewer") { expect(page).not_to have_content("New User") }
    end
  end

  # * Member or Viewer
  describe "Member or Viewer, do NOT display" do
    let(:user) { create(:user_other_than_admin) }

    # * New Sabeel
    it do
      within(".navbar-nav") { expect(page).not_to have_content("Create Sabeel") }
    end
  end
end
