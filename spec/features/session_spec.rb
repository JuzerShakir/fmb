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

            expect(page).to have_css('h2', text: "Login")
        end

        scenario "should be able to login with valid credentials" do
            fill_in "sessions_its", with: "#{@user[:its]}"
            fill_in "sessions_password", with: "#{@password}"

            click_button "Login"

            expect(current_path).to eql root_path("format=html")
            expect(page).to have_content("Afzalus Salam, #{@user.name}")
        end
    end
end