require 'rails_helper'

RSpec.describe "Navbar features" do
    before do
        @user = FactoryBot.create(:user)
        page.set_rack_session(user_id: @user.id)
        visit root_path
    end

    scenario "should have a title" do
        within(".navbar-brand") do
            expect(page).to have_content("FMB")
        end
    end

    # * New Sabeel
    scenario "should have a 'Create Sabeel' link" do
        within(".navbar-nav") do
            expect(page).to have_content("Create Sabeel")
            click_on "Create Sabeel"
            expect(current_path).to eql new_sabeel_path
        end
    end

    # * Statistics
    context "should have a dropdown for Statistics" do
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
    context "should have a dropdown for Resources" do
        scenario "with 'Sabeels' link" do
            within("#resources") do
                expect(page).to have_content("Sabeels")
                click_on "Sabeels"
                expect(current_path).to eql all_sabeels_path
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

    # * Admin
    context "should have a dropdown for Admin" do
        before do
            click_on "Admin"
        end

        scenario "with 'My Profile' link" do
            within("#admin") do
                expect(page).to have_content("My Profile")
                click_on "My Profile"
                expect(current_path).to eql user_path(@user)
            end
        end

        scenario "with 'New User' link" do
            within("#admin") do
                expect(page).to have_content("New User")
                click_on "New User"
                expect(current_path).to eql new_user_path
            end
        end

        scenario "with 'Home' link" do
            within("#admin") do
                expect(page).to have_content("Home")
                click_on "Home"
                expect(current_path).to eql admin_path
            end
        end

        scenario "with 'Log out' link" do
            within("#admin") do
                expect(page).to have_content("Log out")
                click_on "Log out"
                expect(current_path).to eql login_path
            end
        end
    end
end