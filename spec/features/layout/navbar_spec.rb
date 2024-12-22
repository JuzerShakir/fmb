# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Navbar" do
  # * Accessible by logged-in user
  describe "logged in" do
    before do
      sign_in(user)
      visit thaalis_all_path(CURR_YR)
    end

    describe "any user can view" do
      let(:user) { create(:user) }

      # * Statistics
      describe "Statistics dropdown menu" do
        it do
          within("#statistics") { expect(page).to have_link("Sabeels", href: statistics_sabeels_path) }
        end

        it do
          within("#statistics") { expect(page).to have_link("Thaalis", href: statistics_thaalis_path) }
        end
      end

      # * Resources
      describe "Resources dropdown menu" do
        it do
          within("#resources") { expect(page).to have_link("Sabeels", href: sabeels_path) }
        end

        it do
          within("#resources") { expect(page).to have_link("Thaalis", href: thaalis_all_path(CURR_YR)) }
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
          within("#admin") { expect(page).to have_link("All Users", href: users_path) }
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
          within("#member") { expect(page).to have_no_content("Home") }
        end
      end

      # * New User
      it do
        within("#member") { expect(page).to have_no_content("New User") }
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
        within("#viewer") { expect(page).to have_no_content("My Profile") }
      end

      # * Home
      it do
        within("#viewer") { expect(page).to have_no_content("Home") }
      end

      # * New User
      it do
        within("#viewer") { expect(page).to have_no_content("New User") }
      end
    end

    # * Member or Viewer
    describe "Member or Viewer, do NOT display" do
      let(:user) { create(:user_member_or_viewer) }

      # * New Sabeel
      it do
        within(".navbar-nav") { expect(page).to have_no_content("Create Sabeel") }
      end
    end
  end
end
