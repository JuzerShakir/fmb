require "rails_helper"

RSpec.describe "Navbar" do
  context "all users should be shown" do
    before do
      @user = FactoryBot.create(:user)
      page.set_rack_session(user_id: @user.id)
      visit root_path
    end

    scenario "a title" do
      within(".navbar-brand") do
        expect(page).to have_content("FMB")
      end
    end

    # * Statistics
    context "a dropdown for Statistics" do
      scenario "with 'Sabeels' link" do
        within("#statistics") do
          expect(page).to have_content("Sabeels")
          click_on "Sabeels"
          expect(current_path).to eql stats_sabeels_path
        end
      end

      scenario "with 'Thaali Takhmeens' link" do
        within("#statistics") do
          expect(page).to have_content("Thaali Takhmeens")
          click_on "Thaali Takhmeens"
          expect(current_path).to eql takhmeens_stats_path
        end
      end
    end

    # * Resources
    context "a dropdown for Resources" do
      scenario "with 'Sabeels' link" do
        within("#resources") do
          expect(page).to have_content("Sabeels")
          click_on "Sabeels"
          expect(current_path).to eql sabeels_path
        end
      end

      scenario "with 'Thaali Takhmeens' link" do
        within("#resources") do
          expect(page).to have_content("Thaali Takhmeens")
          click_on "Thaali Takhmeens"
          expect(current_path).to eql root_path
        end
      end

      scenario "with 'Transactions' link" do
        within("#resources") do
          expect(page).to have_content("Transactions")
          click_on "Transactions"
          expect(current_path).to eql all_transactions_path
        end
      end
    end
  end

  # * IS Admin
  context "if user is an Admin" do
    before do
      @admin = FactoryBot.create(:admin_user)
      page.set_rack_session(user_id: @admin.id)
      visit root_path
    end

    scenario "show 'Admin' dropdown" do
      within(".navbar-nav") do
        expect(page).to have_css("#admin", text: "Admin")
      end
    end

    # * New Sabeel
    scenario "show 'Create Sabeel' link" do
      within(".navbar-nav") do
        expect(page).to have_content("Create Sabeel")
        click_on "Create Sabeel"
        expect(current_path).to eql new_sabeel_path
      end
    end

    # * My Profile
    scenario "show 'My Profile' link" do
      within("#admin") do
        expect(page).to have_content("My Profile")
        click_on "My Profile"
        expect(current_path).to eql user_path(@admin)
      end
    end

    # * New User
    scenario "show 'New User' link" do
      within("#admin") do
        expect(page).to have_content("New User")
        click_on "New User"
        expect(current_path).to eql new_user_path
      end
    end

    # * Home
    scenario "show 'Home' link" do
      within("#admin") do
        expect(page).to have_content("Home")
        click_on "Home"
        expect(current_path).to eql users_path
      end
    end

    # * Log Out
    scenario "show 'Log out' link" do
      within("#admin") do
        expect(page).to have_content("Log out")
        click_on "Log out"
        expect(current_path).to eql login_path
      end
    end
  end

  # * NOT Admin
  context "if user is NOT an Admin, do NOT show" do
    before do
      @user = FactoryBot.create(:user_other_than_admin)
      page.set_rack_session(user_id: @user.id)
      visit root_path
    end

    # * New Sabeel
    scenario "'Create Sabeel' link" do
      within(".navbar-nav") do
        expect(page).not_to have_content("Create Sabeel")
      end
    end

    # * Home
    scenario "'Home' link" do
      if @user.member?
        within("#member") do
          expect(page).not_to have_content("Home")
        end
      else
        within("#viewer") do
          expect(page).not_to have_content("Home")
        end
      end
    end

    # * New User
    scenario "'New User' link" do
      if @user.member?
        within("#member") do
          expect(page).not_to have_content("New User")
        end
      else
        within("#viewer") do
          expect(page).not_to have_content("New User")
        end
      end
    end
  end

  # * Member
  context "if user is a Member" do
    before do
      @member = FactoryBot.create(:member_user)
      page.set_rack_session(user_id: @member.id)
      visit root_path
    end

    scenario "show 'Member' dropdown" do
      within(".navbar-nav") do
        expect(page).to have_css("#member", text: "Member")
      end
    end

    # * My Profile
    scenario "show 'My Profile' link" do
      within("#member") do
        expect(page).to have_content("My Profile")
        click_on "My Profile"
        expect(current_path).to eql user_path(@member)
      end
    end

    # * Log Out
    scenario "show 'Log out' link" do
      within("#member") do
        expect(page).to have_content("Log out")
        click_on "Log out"
        expect(current_path).to eql login_path
      end
    end
  end

  # * Viewer
  context "if user is a Viewer" do
    before do
      @viewer = FactoryBot.create(:viewer_user)
      page.set_rack_session(user_id: @viewer.id)
      visit root_path
    end

    scenario "have 'viewer' id" do
      within(".navbar-nav") do
        expect(page).to have_css("#viewer")
      end
    end

    # * My Profile
    scenario "do not show 'My Profile' link" do
      within("#viewer") do
        expect(page).not_to have_content("My Profile")
      end
    end

    # * Log Out
    scenario "show 'Log out' link" do
      within("#viewer") do
        expect(page).to have_content("Log out")
        click_on "Log out"
        expect(current_path).to eql login_path
      end
    end
  end
end
