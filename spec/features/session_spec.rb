require 'rails_helper'

RSpec.describe "Sessions features" do
    # * CREATE
    context "creating session" do
        before do
            @password = Faker::Internet.password(min_length: 6, max_length: 72)
            @user = FactoryBot.create(:user, password: @password)

            visit login_path
        end

        scenario "should have a correct url and a heading" do
            expect(current_path).to eql login_path
            expect(page).to have_css('h2', text: "Member Login")
        end

        scenario "should be able to login with valid credentials" do
            fill_in "sessions_its", with: "#{@user[:its]}"
            fill_in "sessions_password", with: "#{@password}"

            click_button "Login"

            expect(current_path).to eql root_path("format=html")
            first_name = @user.name.split.first
            expect(page).to have_content("Afzalus Salam, #{first_name} bhai!")
            within("#admin") do
                expect(page).to have_link("Admin")
            end
        end

        scenario "should NOT be able to login with invalid credentials" do
            fill_in "sessions_its", with: "#{@user[:its]}"
            fill_in "sessions_password", with: ""

            click_button "Login"
            expect(page).to have_content("Invalid credentials!")
        end
    end

    # * DESTROY
    context "deleting session" do
        before do
            @user = FactoryBot.create(:user)
            page.set_rack_session(user_id: @user.id)
            visit root_path
            click_on "Log out"
        end

        scenario "should redirect to login_path with flash message" do
            expect(current_path).to eql login_path
            expect(page).to have_content("Logged Out!")
        end

        scenario "should NOT show the navbar" do
            expect(page).not_to have_css("navbar")
        end
    end
end