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
        it "has links to Sabeels & Thaalis" do
          within("#statistics") do
            expect(page).to have_link("Sabeels", href: statistics_sabeels_path)
            expect(page).to have_link("Thaalis", href: statistics_thaalis_path)
          end
        end
      end

      # * Resources
      describe "Resources dropdown menu" do
        it "has links to Sabeels, Thaalis & Transactions" do
          within("#resources") do
            expect(page).to have_link("Sabeels", href: sabeels_path)
            expect(page).to have_link("Thaalis", href: thaalis_all_path(CURR_YR))
            expect(page).to have_link("Transactions", href: transactions_all_path)
          end
        end
      end
    end

    # * Admin
    context "when admin" do
      let(:user) { create(:admin_user) }

      it "Show 'Admin' dropdown & Create Sabeel button" do
        within(".navbar-nav") do
          expect(page).to have_css("#admin", text: "Admin")
          expect(page).to have_link("Create Sabeel", href: new_sabeel_path)
        end
      end

      it "'Admin' dropdown" do
        within("#admin") do
          expect(page).to have_link("My Profile", href: user_path(user))
          expect(page).to have_link("New User", href: new_user_path)
          expect(page).to have_link("All Users", href: users_path)
          expect(page).to have_link("Log out", href: destroy_path)
        end
      end
    end

    # * Member
    context "when Member" do
      let(:user) { create(:member_user) }

      it "Show 'Member' dropdown" do
        within(".navbar-nav") { expect(page).to have_css("#member", text: "Member") }
      end

      it "'Member' dropdown" do
        within("#member") do
          expect(page).to have_link("My Profile", href: user_path(user))
          expect(page).to have_link("Log out", href: destroy_path)
        end
      end
    end

    # * Viewer
    context "when Viewer" do
      let(:user) { create(:viewer_user) }

      it "has 'viewer' id" do
        within(".navbar-nav") { expect(page).to have_css("#viewer") }
      end

      it "within 'viewer' id" do
        expect(page).to have_link("Log out", href: destroy_path)
        expect(page).to have_no_content("My Profile")
      end
    end

    # * Member or Viewer
    context "when Member or Viewer" do
      let(:user) { create(:user_member_or_viewer) }

      it "within the navbar" do
        within(".navbar-nav") do
          expect(page).to have_no_content("Create Sabeel")
          expect(page).to have_no_content("Home")
          expect(page).to have_no_content("New User")
        end
      end
    end
  end
end
