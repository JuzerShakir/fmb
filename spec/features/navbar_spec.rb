require 'rails_helper'

RSpec.describe "Navbar features" do
    before do
        visit root_path
    end

    scenario "should have a title" do
        within(".navbar-brand") do
            expect(page).to have_content("FMB")
        end
    end

    scenario "should have a 'Add New Sabeel' link" do
        within(".navbar-nav") do
            expect(page).to have_content("Add New Sabeel")
            click_on "Add New Sabeel"
            expect(current_path).to eql new_sabeel_path
        end
    end

    context "should have a dropdown for Statistics" do
        scenario "with 'Sabeels' link" do
            within("#statistics") do
                expect(page).to have_content("Sabeels")
                click_on "Sabeels"
                expect(current_path).to eql sabeels_stats_path
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
end