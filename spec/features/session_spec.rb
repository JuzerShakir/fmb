require 'rails_helper'

RSpec.describe "Sessions templates" do
    before do
        @password = Faker::Internet.password(min_length: 6, max_length: 72)
        @user = FactoryBot.create(:user, password: @password)

        visit login_path
    end

    # * NEW
    context "'new'" do
        scenario "should have a correct url and a heading" do
            expect(current_path).to eql login_path
            expect(page).to have_css('h2', text: "Faizul Mawaid il Burhaniyah")
        end
    end

    # * CREATE
    context "creating session"  do
        scenario "should be able to login with valid credentials" do
            fill_in "sessions_its", with: "#{@user[:its]}"
            fill_in "sessions_password", with: "#{@password}"

            click_button "Login"

            expect(current_path).to eql root_path("format=html")
            first_name = @user.name.split.first
            expect(page).to have_content("Afzalus Salam, #{first_name} bhai!")
        end

        scenario "should NOT be able to login with invalid credentials" do
            fill_in "sessions_its", with: "#{@user[:its]}"
            fill_in "sessions_password", with: ""

            click_button "Login"
            expect(page).to have_content("Invalid credentials!")
        end

        scenario "should show footer" do
            expect(page).to have_css("#footer")
        end
    end

    # * DESTROY
    context "'destroy'" do
        before do
            page.set_rack_session(user_id: @user.id)
            visit root_path
            click_on "Log out"
        end

        scenario "should redirect to login_path with flash message" do
            expect(current_path).to eql login_path
            expect(page).to have_content("Logged Out!")
        end

        scenario "should NOT show the navbar" do
            expect(page).not_to have_css(".navbar")
        end
    end
end