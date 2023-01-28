require 'rails_helper'

RSpec.describe "Sessions features" do
    # * CREATE
    context "creating session" do
        before do
            visit root_path
            @password = Faker::Internet.password(min_length: 6, max_length: 72)
            @user = FactoryBot.create(:user, password: @password)

            click_on "Login"
            expect(current_path).to eql login_path

            expect(page).to have_css('h2', text: "Member Login")
        end

        scenario "should be able to login with valid credentials" do
            fill_in "sessions_its", with: "#{@user[:its]}"
            fill_in "sessions_password", with: "#{@password}"

            click_button "Login"

            expect(current_path).to eql root_path("format=html")
            expect(page).to have_content("Afzalus Salam, #{@user.name}")
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

        scenario "should show 'Login' link" do
            expect(page).to have_link("Login")
        end
    end
end