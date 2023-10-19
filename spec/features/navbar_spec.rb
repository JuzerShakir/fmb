# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Navbar" do
  # rubocop:disable RSpec/BeforeAfterAll
  before do
    page.set_rack_session(user_id: user.id)
    visit root_path
  end
  # rubocop:enable RSpec/BeforeAfterAll

  describe "'Anyone' who have logged in displays" do
    let(:user) { create(:user) }

    # * Statistics
    describe "Statistics dropdown menu" do
      it "has link of sabeels stats" do
        within("#statistics") { expect(page).to have_link("Sabeels", href: stats_sabeels_path) }
      end

      it "has link of thaali takhmeen stats" do
        within("#statistics") { expect(page).to have_link("Thaali Takhmeen", href: takhmeens_stats_path) }
      end
    end

    # * Resources
    describe "Resources dropdown menu" do
      it "has link of sabeels index action" do
        within("#resources") { expect(page).to have_link("Sabeels", href: sabeels_path) }
      end

      it "has link of thaali takhmeen index action" do
        within("#resources") { expect(page).to have_link("Thaali Takhmeens", href: root_path) }
      end

      it "has link of transactions index action" do
        within("#resources") { expect(page).to have_link("Transactions", href: transactions_all_path) }
      end
    end
  end

  # * Admin
  context "when admin" do
    describe "has logged in, it displays" do
      let(:user) { create(:admin_user) }

      it "'Admin' dropdown" do
        within(".navbar-nav") { expect(page).to have_css("#admin", text: "Admin") }
      end

      # * New Sabeel
      it "'Create Sabeel' link" do
        within(".navbar-nav") { expect(page).to have_link("Create Sabeel", href: new_sabeel_path) }
      end

      # * My Profile
      it "'My Profile' link" do
        within("#admin") { expect(page).to have_link("My Profile", href: user_path(user)) }
      end

      # * New User
      it "'New User' link" do
        within("#admin") { expect(page).to have_link("New User", href: new_user_path) }
      end

      # * Home
      it "'Home' link" do
        within("#admin") { expect(page).to have_link("Home", href: users_path) }
      end

      # * Log Out
      it "'Log out' link" do
        within("#admin") { expect(page).to have_link("Log out", href: destroy_path) }
      end
    end

    # * NOT Admin
    describe "has NOT logged in, do NOT display" do
      let(:user) { create(:user_other_than_admin) }

      # * New Sabeel
      it "'Create Sabeel' link" do
        within(".navbar-nav") do
          expect(page).not_to have_content("Create Sabeel")
        end
      end
    end
  end

  # * Member
  context "when Member, it displays" do
    let(:user) { create(:member_user) }

    it "'Member' dropdown" do
      within(".navbar-nav") { expect(page).to have_css("#member", text: "Member") }
    end

    # * My Profile
    it "'My Profile' link" do
      within("#member") { expect(page).to have_link("My Profile", href: user_path(user)) }
    end

    it "NO 'New User' link" do
      within("#member") { expect(page).not_to have_content("New User") }
    end

    it "NO 'Home' link" do
      within("#member") { expect(page).not_to have_content("Home") }
    end

    # * Log Out
    it "'Log out' link" do
      within("#member") { expect(page).to have_link("Log out", href: destroy_path) }
    end
  end

  # * Viewer
  context "when Viewer, it displays" do
    let(:user) { create(:viewer_user) }

    it "have 'viewer' id" do
      within(".navbar-nav") { expect(page).to have_css("#viewer") }
    end

    # * My Profile
    it "NO 'My Profile' link" do
      within("#viewer") { expect(page).not_to have_content("My Profile") }
    end

    it "NO 'Home' link" do
      within("#viewer") { expect(page).not_to have_content("Home") }
    end

    it "NO 'New User' link" do
      within("#viewer") { expect(page).not_to have_content("New User") }
    end

    # * Log Out
    it "'Log out' link" do
      within("#viewer") { expect(page).to have_link("Log out", href: destroy_path) }
    end
  end
end
